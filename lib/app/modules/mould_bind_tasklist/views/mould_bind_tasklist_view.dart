import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/utils/logger.dart';

import '../../../entity/mould_bind.dart';
import '../controllers/mould_bind_tasklist_controller.dart';

/**
 * 模具绑定列表
 */
class MouldBindTasklistView extends GetView<MouldBindTasklistController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MouldBindTasklistView'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('获取数据'),
          onPressed: () {
            controller.getMouldTaskList();
          },
        ),
      ),
    );
  }
}
