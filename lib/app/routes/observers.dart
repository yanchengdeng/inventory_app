import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/utils/logger.dart';
import '../modules/inventory_tasklist/controllers/inventory_tasklist_controller.dart';
import '../modules/inventory_tasklist_sub_level/controllers/inventory_tasklist_sub_level_controller.dart';
import '../modules/mould_bind_tasklist/controllers/mould_bind_tasklist_controller.dart';
import '../modules/mould_bind_tasklist_sub_level/controllers/mould_bind_mouldlist_controller.dart';

class RouteObservers<R extends Route<dynamic>> extends RouteObserver<R> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    var name = route.settings.name ?? '';
    if (name.isNotEmpty) AppPages.history.add(name);
    print('didPush');
    print(AppPages.history);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    Log.d("离开页面：${route.settings.name}");
    AppPages.history.remove(route.settings.name);

    ///离开模具绑定读取页  回到上一页刷新
    if (route.settings.name == Routes.MOULD_READ_RESULT) {
      var mouldSubLevel = Get.find<MouldBindMouldListController>();
      mouldSubLevel.refresh();
    }

    ///离开模具绑定搜索页  回到上一页刷新
    if (route.settings.name == Routes.MOULD_BIND_MOULDLIST) {
      var mouldSubLevel = Get.find<MouldBindTaskListController>();
      mouldSubLevel.refresh();
    }

    ///离开资产盘点读取页 回到上一页刷新
    if (route.settings.name == Routes.INVENTORY_TASK_HANDLER) {
      var inventorySearchController =
          Get.find<InventoryTasklistSubLevelController>();
      inventorySearchController.refresh();
    }

    /// 离开盘点搜索页 回到上一页刷新

    if (route.settings.name == Routes.INVENTORY_TASKLIST_SUB_LEVEL) {
      var inventoryControll = Get.find<InventoryTasklistController>();
      inventoryControll.refresh();
    }
    print('didPop');
    print(AppPages.history);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      var index = AppPages.history.indexWhere((element) {
        return element == oldRoute?.settings.name;
      });
      var name = newRoute.settings.name ?? '';
      if (name.isNotEmpty) {
        if (index > 0) {
          AppPages.history[index] = name;
        } else {
          AppPages.history.add(name);
        }
      }
    }
    print('didReplace');
    print(AppPages.history);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    AppPages.history.remove(route.settings.name);
    print('didRemove');
    print(AppPages.history);
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }
}
