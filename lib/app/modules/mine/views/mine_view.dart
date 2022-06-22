import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/mine_controller.dart';

/**
 * 用户信息页面 
 */
class MineView extends GetView<MineController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('我的')),
    );
  }
}
