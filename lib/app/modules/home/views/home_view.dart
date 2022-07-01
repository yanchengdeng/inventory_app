import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../controllers/home_controller.dart';

/**
 * 首页
 */
class HomeView extends GetView<HomeController> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  final controller = Get.put(HomeController());

  void _onRefresh() async {
    // monitor network fetch
    _refreshController.refreshCompleted();
    await controller.getMouldTaskList();
    await controller.getInventoryList();
    // if failed,use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Row(children: [
          Expanded(
              //使用InkWell 控件包裹可以增加点击事件
              child: Obx(() => controller.state.mouldBindTaskList == null
                  ? InkWell()
                  : InkWell(
                      onTap: () {
                        Get.toNamed(Routes.MOULD_BIND_TASKLIST);
                      },
                      child: homeItem(
                          title: '模具绑定',
                          iconFileName: 'images/setting.png',
                          unFinished: controller
                              .state.mouldBindTaskList?.data?.unfinished)))),
          Expanded(
              child: Obx(() => controller.state.inventoryList == null
                  ? InkWell()
                  : InkWell(
                      onTap: () => {Get.toNamed(Routes.INVENTORY_TASKLIST)},
                      child: homeItem(
                          title: '资产盘点',
                          iconFileName: 'images/invertory.png',
                          unFinished: controller
                              .state.inventoryList?.data?.unfinished))))
        ]),
      ),
    );
  }
}
