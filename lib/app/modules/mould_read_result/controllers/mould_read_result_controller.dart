import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/ReadLabelInfo.dart';
import 'package:inventory_app/app/entity/UploadLabelParams.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../../../apis/file_api.dart';
import '../../../entity/LocationInfo.dart';
import '../../../entity/MouldBindTask.dart';
import '../../home/controllers/home_controller.dart';

class MouldReadResultController extends GetxController {
  ///是否显示全部
  var isShowAllInfo = false.obs;

  ///当前是否为rfid  否则为 二维码扫描 切换要清除前面数据 给弹框提示
  var isRfidReadStatus = true.obs;

  ///图片信息  全部照片
  var imageUrlAll = "".obs;

  ///铭牌照片
  var imageUrlMp = "".obs;

  ///型腔照片
  var imageUrlXq = "".obs;

  var locationInfo = LocationInfo().obs;

  ///读取rfid数据
  var isReadData = Rx<bool>(true);

  ///读取标签方式  0  两者  1  rfid  2 扫码
  var readLabelType = 0.obs;

  ///RFID SDK 通信channel  只允许上下行 一次交互
  static const String READ_RFID_DATA_CHANNEL = 'mould_read_result/blue_teeth';

  ///rfid 开始通过蓝牙获取信息
  static const String START_READ_RFID_DATA = 'startReadRfid';

  ///rfid 停止通过蓝牙获取信息
  static const String STOP_READ_RFID_DATA = 'stopReadRfidSdk';

  /// 获取gps经纬度
  static const String GET_GPS_LAT_LNG = 'getGpsLatLng';

  /// 初始化rfid sdk 和 扫描sdk
  static const String INIT_RFID_AND_SCAN = 'init_rfid_and_scan';

  /// 停止rfid sdk 和 扫描sdk
  static const String STOP_RFID_AND_SCAN = 'stop_rfid_and_scan';

  ///只初始化rfid
  static const INIT_RFID_ONLY = 'init_rfid_and_only';

  ///只初始化扫描
  static const INIT_SCAN_ONLY = 'init_scan_and_only';

  ///flutter 与android 原生交互  只能一次发送一个回复 模式
  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

  ///模具资产信息
  var assertBindTaskInfo = MouldList().obs;

  final homeController = Get.find<HomeController>();

  /// 可以实现 android 低层持续向flutter 发送消息
  final _eventChannel = const EventChannel('event_channel_rfid');

  ///读取数据
  var readDataContent = ReadLabelInfo().obs;

  ///所有显示标签   已有标签+ 读取标签
  var showAllLabels = [].obs;

  ///开始读 、停止读
  startReadRfidData() async {
    if (isReadData.value) {
      var rfidDataFromAndroid =
          (await platform.invokeMethod(START_READ_RFID_DATA));
      if (rfidDataFromAndroid) {
        isReadData.value = false;
      }
    } else {
      var rfidDataFromAndroid =
          (await platform.invokeMethod(STOP_READ_RFID_DATA));
      if (rfidDataFromAndroid) {
        isReadData.value = true;
      }
    }
  }

  /// 获取经纬度
  getGpsLagLng() async {
    var latLng = await platform.invokeMethod(GET_GPS_LAT_LNG);
    Log.d("获取定位信息：$latLng");
    var location = jsonDecode(latLng);
    locationInfo.value = LocationInfo.fromJson(location);
  }

  @override
  void onInit() {
    super.onInit();

    _eventChannel.receiveBroadcastStream().listen((event) {
      var jsonLabels = jsonDecode(event);
      readDataContent.value = ReadLabelInfo.fromJson(jsonLabels);
      readDataContent.value.data?.forEach((element) {
        if (!showAllLabels.contains(element)) {
          showAllLabels.add(element);
        }
      });

      print("yancheng-返回到fullter 上标签数据：--${showAllLabels}");
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    ///需要做处理 关闭读取rfid 和扫描
    platform.invokeMethod(STOP_RFID_AND_SCAN);
  }

  void refreshImage(PhotoInfo uploadImageInfo) {
    if (uploadImageInfo.photoType == PHOTO_TYPE_ALL) {
      imageUrlAll.value = uploadImageInfo.fullPath ?? "";
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_MP) {
      imageUrlMp.value = uploadImageInfo.fullPath ?? "";
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_XQ) {
      imageUrlXq.value = uploadImageInfo.fullPath ?? "";
    }
  }

  ///获取编辑信息
  void getTaskInfo(taskNo, assetNo) async {
    EasyLoading.show(status: "加载中...");
    await FileApi.getFileToken();
    assertBindTaskInfo.value = homeController.mouldBindList.value.data
            ?.where((element) => element.taskNo == taskNo)
            ?.first
            ?.mouldList
            ?.where((element) => element.assetNo == assetNo)
            ?.first ??
        MouldList();

    ///默认添加已有标签
    assertBindTaskInfo.value.bindLabels?.forEach((element) {
      if (!showAllLabels.contains(element)) {
        showAllLabels.add(element);
      }
    });
    Log.d("读取页数据：${assertBindTaskInfo.value.toJson()}");
    if (assertBindTaskInfo.value.labelType == 0) {
      readLabelType.value = 0;
      await platform.invokeMethod(INIT_RFID_AND_SCAN);
    } else if (assertBindTaskInfo.value.labelType == LABEL_RFID) {
      readLabelType.value = LABEL_RFID;
      await platform.invokeMethod(INIT_RFID_ONLY);
    } else if (assertBindTaskInfo.value.labelType == LABEL_SCAN) {
      readLabelType.value = LABEL_SCAN;
      await platform.invokeMethod(INIT_SCAN_ONLY);
    }
    EasyLoading.dismiss();
  }

  ///保存
  saveInfo(String taskType, String taskNo) async {
    toastInfo(msg: "保存成功");
    Get.back();
  }
}
