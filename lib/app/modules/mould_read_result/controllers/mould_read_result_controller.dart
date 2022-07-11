import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MouldReadResultController extends GetxController {

  var rfidData = Rx<String>("no data");
  var rfidReadData = Rx<List<String>>(List.empty());

///RFID SDK 通信channel
  static const String READ_RFID_DATA_CHANNEL = 'mould_read_result/blue_teeth';

  ///初始化rfid_sdk  绑定选择蓝牙
  static const String INIT_RFID_SDK = 'initRfidSdk';
  ///rfid 开始通过蓝牙获取信息
  static const String START_READ_RFID_DATA = 'startReadRfid';
  ///rfid 停止通过蓝牙获取信息
  static const String STOP_READ_RFID_DATA = 'stopReadRfidSdk';



  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

  initRfidData() async{
    var rfidDataFromAndroid = (await platform.invokeMethod(INIT_RFID_SDK)) ;
    rfidData.value = rfidDataFromAndroid;
  }


  startReadRfidData() async{
    var rfidDataFromAndroid = (await platform.invokeMethod(START_READ_RFID_DATA)) ;
    rfidReadData.value = rfidDataFromAndroid;
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
}
