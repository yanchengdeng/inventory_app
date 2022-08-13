import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/entity/UploadLabelParams.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../../../entity/cache_data.dart';
import '../../../entity/MouldBindTask.dart';
import '../../../services/storage.dart';
import '../../../utils/cache.dart';
import '../../../values/server.dart';
import '../../../values/storage.dart';
import '../../home/controllers/home_controller.dart';

class MouldReadResultController extends GetxController {
  ///是否显示全部
  var isShowAllInfo = false.obs;

  ///当前是否为rfid  否则为 二维码扫描 切换要清除前面数据 给弹框提示
  var isRfidReadStatus = true.obs;

  ///rfid  或者 扫描读取数据
  var readDataContent = Rx<String>('');

  ///图片信息  全部照片
  var imageUrlAll = Rx<PhotoInfo?>(null);

  ///铭牌照片
  var imageUrlMp = Rx<PhotoInfo?>(null);

  ///型腔照片
  var imageUrlXq = Rx<PhotoInfo?>(null);

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

  /// 获取扫描标签
  static const String GET_SCAN_LABEL = 'scan_label';

  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

  ///模具资产信息
  var assertBindTaskInfo =  MouldList().obs;

  final homeController = Get.find<HomeController>();

  /// 可以实现 android 低层持续向flutter 发送消息
  final _eventChannel = const EventChannel('event_channel_name');

  ///开始读 、停止读
  startReadRfidData() async {
    if (isReadData.value) {
      var rfidDataFromAndroid =
          (await platform.invokeMethod(START_READ_RFID_DATA));
      readDataContent.value = rfidDataFromAndroid;
      // isReadData.value = false;
      // if (_assertBindTaskInfo.value?.bindLabels?.isEmpty ?? true) {
      //   _assertBindTaskInfo.value?.bindLabels?.add(BindLabels());
      // }
      // _assertBindTaskInfo.value?.labelNo = readDataContent.value;
    } else {
      isReadData.value = true;
      var rfidDataFromAndroid =
          (await platform.invokeMethod(STOP_READ_RFID_DATA));
      readDataContent.value = rfidDataFromAndroid;
      // if (_assertBindTaskInfo.value?.bindLabels?.isEmpty ?? true) {
      //   _assertBindTaskInfo.value?.bindLabels?.add(BindLabels());
      // }
      // _assertBindTaskInfo.value?.labelNo = readDataContent.value;
    }
  }

  /// 获取经纬度
  getGpsLagLng() async {
    var latLng = await platform.invokeMethod(GET_GPS_LAT_LNG);
    gpsData.value = latLng;

  }

  /// 获取扫描label
  getScanLabel() async {
    var scanLabel = await platform.invokeMethod(GET_SCAN_LABEL) as String;
    readDataContent.value = scanLabel;

  }

  @override
  void onInit() {
    super.onInit();

    _eventChannel.receiveBroadcastStream().listen((event) {
      print("yancheng-接受数据：--$event");
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {

    ///需要做处理 关闭读取rfid
    if (!isReadData.value) {
      //正在读 则需要关闭
      platform.invokeMethod(STOP_READ_RFID_DATA);
    }
  }

  void refreshImage(PhotoInfo uploadImageInfo) {

  }

  ///清除页面信息  图片  标签
  clearData() {
    ///读取状态
    isReadData.value = true;

    ///扫描标签
    readDataContent.value = '';
  }

  ///获取编辑信息
  void getTaskInfo(taskNo, assetNo) async {
    assertBindTaskInfo.value =  homeController.mouldBindList.value.data
        ?.where((element) => element.taskNo == taskNo)?.first?.mouldList
        ?.where((element) => element.assetNo == assetNo)?.first ?? MouldList();
  }

  ///保存
  saveInfo(String taskType, String taskNo) async {

    toastInfo(msg: "保存成功");
    Get.back();
  }
}
