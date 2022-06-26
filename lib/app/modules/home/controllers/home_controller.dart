import 'package:get/get.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/apis/mould_task_api.dart';
import 'package:inventory_app/app/modules/home/HomeState.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/utils/logger.dart';

class HomeController extends GetxController {
  //响应式变量
  final state = HomeState();

  //获取模具绑定列表
  getMouldTaskList() async {
    state.mouldBindTaskList =
        await MouldTaskApi.getMouldTaskList(CommonUtils.getCommonParams());
  }

  // 获取资产盘点列表
  getInventoryList() async {
    state.inventoryList =
        await InventoryApi.getInventoryList(CommonUtils.getCommonParams());
  }

  @override
  void onInit() {
    super.onInit();
    EasyLoading.show(status: "获取中...");
    Log.d("HomeController--onInit()");
  }

  @override
  void onReady() {
    super.onReady();
    Log.d("HomeController--onReady()");
  }

  @override
  void onClose() {
    Log.d("HomeController--onClose()");
  }
}
