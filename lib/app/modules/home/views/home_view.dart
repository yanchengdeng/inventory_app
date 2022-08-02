import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import '../controllers/home_controller.dart';

/**
 * 首页
 */
class HomeView extends GetView<HomeController> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: Row(children: [
        Expanded(
            //使用InkWell 控件包裹可以增加点击事件
            child: Obx(() => InkWell(
                onTap: () {
                  Get.toNamed(Routes.MOULD_BIND_TASKLIST);
                },
                child: homeItem(
                    title: '模具绑定',
                    iconFileName: 'images/setting.png',
                    unFinished: CacheUtils.to.mouldBindTaskList == null
                        ? 0
                        : CacheUtils.to.mouldBindTaskList?.unfinished)))),
        Expanded(
            child: Obx(() => InkWell(
                onTap: () => {Get.toNamed(Routes.INVENTORY_TASKLIST)},
                child: homeItem(
                    title: '资产盘点',
                    iconFileName: 'images/invertory.png',
                    unFinished: CacheUtils.to.inventoryList == null
                        ? 0
                        : CacheUtils.to.inventoryList.unfinished))))
      ]),
    );
  }
}
