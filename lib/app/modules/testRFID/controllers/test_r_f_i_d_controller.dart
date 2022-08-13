import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TestRFIDController extends GetxController {
  //TODO: Implement TestRFIDController
  ///RFID SDK 通信channel
  static const String READ_RFID_DATA_CHANNEL = 'mould_read_result/blue_teeth';

  /// 获取gps经纬度
  static const String GET_GPS_LAT_LNG = 'getGpsLatLng';

  ///rfid 开始通过蓝牙获取信息
  static const String START_READ_RFID_DATA = 'startReadRfid';

  ///rfid 停止通过蓝牙获取信息
  static const String STOP_READ_RFID_DATA = 'stopReadRfidSdk';

  ///flutter 向原生发起指令
  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

///原生向 flutter  发消息 可连续发送
  final _eventChannel = const EventChannel('event_channel_name');

  ///rfid 读取数据
  var readDataContent = Rx<String>('');

  /// 扫描读取数据
  var scanDataContent = Rx<String>('');
  ///经纬度数据121.23312,1232.32
  var gpsData = Rx<String>('');

  var isReadData = true;



  ///开始读 、停止读
  startReadRfidData(bool startOk) async {
    if (startOk) {

      var rfidDataFromAndroid =
      (await platform.invokeMethod(START_READ_RFID_DATA));

    } else {

      var rfidDataFromAndroid =
      (await platform.invokeMethod(STOP_READ_RFID_DATA));
    }
  }

  /// 获取经纬度
  getGpsLagLng() async {
    var latLng = await platform.invokeMethod(GET_GPS_LAT_LNG);
    gpsData.value = latLng;


  }

  /// 获取扫描label
  getScanLabel() async {

  }


  @override
  void onInit() {
    super.onInit();
    _eventChannel.receiveBroadcastStream().listen((event) {
      print("yancheng-接受数据：--$event");
      readDataContent.value = "接受数据：--$event";
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
