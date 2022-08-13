import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/ReadLabelInfo.dart';
import 'package:inventory_app/app/entity/UploadLabelParams.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../../../apis/file_api.dart';
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

  ///经纬度数据121.23312,1232.32
  var gpsData = Rx<String>('');

  ///读取rfid数据
  var isReadData = Rx<bool>(true);

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

  ///flutter 与android 原生交互  只能一次发送一个回复 模式
  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

  ///模具资产信息
  var assertBindTaskInfo = MouldList().obs;

  final homeController = Get.find<HomeController>();

  /// 可以实现 android 低层持续向flutter 发送消息
  final _eventChannel = const EventChannel('event_channel_rfid');

  ///读取数据
  var readDataContent = ReadLabelInfo().obs;

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
    gpsData.value = latLng;
  }

  @override
  void onInit() {
    super.onInit();
    platform.invokeMethod(INIT_RFID_AND_SCAN);
    _eventChannel.receiveBroadcastStream().listen((event) {
      var jsonLabels = jsonDecode(event);
      readDataContent.value = ReadLabelInfo.fromJson(jsonLabels);
      print("yancheng-返回到fullter 上标签数据：--${readDataContent.value}");
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
    await FileApi.getFileToken();
    assertBindTaskInfo.value = homeController.mouldBindList.value.data
            ?.where((element) => element.taskNo == taskNo)
            ?.first
            ?.mouldList
            ?.where((element) => element.assetNo == assetNo)
            ?.first ??
        MouldList();

    Log.d("读取页数据：${assertBindTaskInfo.value.toJson()}");
  }

  ///保存
  saveInfo(String taskType, String taskNo) async {
    toastInfo(msg: "保存成功");
    Get.back();
  }
}
