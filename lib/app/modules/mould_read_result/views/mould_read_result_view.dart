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
      body: Column(children: [
        ElevatedButton(
          child: Text('连接蓝牙'),
          onPressed: () => {controller.initRfidData()},
        ),
        Obx(() => Text('结果${controller.rfidData}')),
        ElevatedButton(
          child: Obx(() => getReadButton()),
          onPressed: () => {controller.startReadRfidData()},
        ),
        Obx(() => Text('结果${controller.rfidData}')),
      ]),
    );
  }

  Widget getReadButton() {
    if (controller.isReadData.value) {
      return Text('开始读取');
    } else {
      return Text("停止读取");
    }
  }
}
