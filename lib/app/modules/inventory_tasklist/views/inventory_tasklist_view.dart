import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/inventory_tasklist_controller.dart';

/**
 * 资产盘点列表
 */
class InventoryTasklistView extends GetView<InventoryTasklistController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InventoryTasklistView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'InventoryTasklistView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
