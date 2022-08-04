import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../entity/cache_data.dart';

class MouldReadResultController extends GetxController {
  var isShowAllInfo = false.obs;

  // var rfidData = Rx<String>("no data");
  var rfidReadData = Rx<String>('');

  ///文件信息
  var imageUrl = Rx<UploadImageInfo?>(null);

  ///经纬度数据121.23312,1232.32
  var gpsData = Rx<String?>('');

  ///扫描标签
  var scanLabelData = Rx<String?>('');

  ///读取rfid数据
  var isReadData = Rx(true);

  ///RFID SDK 通信channel
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

  ///开始读 、停止读
  startReadRfidData() async {
    if (isReadData.value) {
      var rfidDataFromAndroid =
          (await platform.invokeMethod(START_READ_RFID_DATA));
      rfidReadData.value = rfidDataFromAndroid;
      isReadData.value = false;
    } else {
      isReadData.value = true;
      var rfidDataFromAndroid =
          (await platform.invokeMethod(STOP_READ_RFID_DATA));
      rfidReadData.value = rfidDataFromAndroid;
    }
  }

  /// 获取经纬度
  getGpsLagLng() async {
    var latLng = await platform.invokeMethod(GET_GPS_LAT_LNG);
    gpsData.value = latLng;
  }

  /// 获取扫描label
  getScanLabel() async {
    var scanLabel = await platform.invokeMethod(GET_SCAN_LABEL);
    scanLabelData.value = scanLabel;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void refreshImage(UploadImageInfo uploadImageInfo) {
    imageUrl.value = uploadImageInfo;
  }
}
