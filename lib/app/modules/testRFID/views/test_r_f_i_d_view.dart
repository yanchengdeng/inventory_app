import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test_r_f_i_d_controller.dart';

class TestRFIDView extends GetView<TestRFIDController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestRFIDView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: ()=>{
              controller.getGpsLagLng()
            }, child: Text('获取定位')),

            Text('定位：${controller.gpsData}'),

            ElevatedButton(onPressed: ()=>{
              controller.startReadRfidData(true)

            }, child: Text('读取RFID')),
            ElevatedButton(onPressed: ()=>{
              controller.startReadRfidData(false)
            }, child: Text('停止读取RFID')),

            Text("RFID数据： ${controller.readDataContent}"),


            Text('红外线扫描结果：${controller.gpsData}'),



          ],
        )
      ),
    );
  }
}
