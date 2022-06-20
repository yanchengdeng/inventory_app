import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('首页'),
        ),
        body: Container(
          child: Row(
            children: [
              Expanded(
                  child: homeItem(
                      title: '模具绑定', iconFileName: 'images/setting.png')),
              Expanded(
                  child: homeItem(
                      title: '资产盘点', iconFileName: 'images/invertory.png')),
            ],
          ),
        ));
  }
}
