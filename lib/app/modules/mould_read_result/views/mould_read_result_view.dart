import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../style/text_style.dart';
import '../controllers/mould_read_result_controller.dart';
/**
 * 模具读取结果
 */

class MouldReadResultView extends GetView<MouldReadResultController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('读取结果'),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () => {Get.toNamed(Routes.TAKE_PHOTO)},
              child: Text('拍照')),
          ElevatedButton(
              onPressed: () => {controller.getGpsLagLng()},
              child: Text('获取经纬度')),
          Obx(() => Text('经纬度：${controller.gpsData.value}'))
        ],
      )),
    );
  }
}
