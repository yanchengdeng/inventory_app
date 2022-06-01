import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/style/color.dart';

import '../../home/views/home_view.dart';
import '../../mine/views/mine_view.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            children: [
              HomeView(),
              MineView(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor.accentColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "首页"
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: '我的'
            ),
          ],
        ),
      );
    });
  }
}


