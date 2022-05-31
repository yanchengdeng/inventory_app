import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/mine_controller.dart';

class MineView extends GetView<MineController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('我的')),
    );
  }
}
