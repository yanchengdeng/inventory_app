import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mould_read_result_controller.dart';
/**
 * 模具读取结果
 */

class MouldReadResultView extends GetView<MouldReadResultController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MouldReadResultView'),
        centerTitle: true,
      ),
      body: Column(
        children:[ 
          ElevatedButton(
          child: Text('连接蓝牙'),
          onPressed: ()=>{
            controller.initRfidData()
          },
        ),
        Obx(() => Text('结果${controller.rfidData}')),

          ElevatedButton(
            child: Text('读取数据'),
            onPressed: ()=>{
              controller.startReadRfidData()
            },
          ),
          Obx(() => Text('结果${controller.rfidData}')),


        ]
      ),
    );
  }
}
