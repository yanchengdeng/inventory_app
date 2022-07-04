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
          child: Text('获取android方法'),
          onPressed: ()=>{
            controller.readRfidData()
          },
        ),
        Obx(() => Text('结果${controller.rfidData}'))]
      ),
    );
  }
}
