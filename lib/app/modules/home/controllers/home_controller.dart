import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/apis/mould_task_api.dart';
import 'package:inventory_app/app/modules/home/HomeState.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/utils/logger.dart';
import '../../../entity/inventory_list.dart';
import '../../../entity/mould_bind.dart';
import '../../../store/user.dart';
import '../../../utils/cache.dart';

class HomeController extends GetxController {
  ///响应式变量
  final state = HomeState();

  ///获取模具绑定列表
  getMouldTaskList() async {
    MouldBindList mouldBindList = await MouldTaskApi.getMouldTaskList();
    await CacheUtils.to.saveMouldTask(mouldBindList.data);
  }

  /// 获取资产盘点列表
  getInventoryList() async {
    InventoryList inventoryList = await InventoryApi.getInventoryList();
    await CacheUtils.to.saveInventoryTask(inventoryList.data);
  }

  ///已完成的判断任务
  var _inventoryFinishedList = Rx<InventroyData?>(null);

  set inventoryFinishedList(value) => _inventoryFinishedList.value = value;

  get inventoryFinishedList => _inventoryFinishedList.value;

  /// 获取已完成的资产盘点列表
  getInventoryFinishedList(int page) async {
    InventoryList inventoryList =
        await InventoryApi.getInventoryFinishedList(page);
    _inventoryFinishedList.value = inventoryList.data;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    Log.d("HomeController--onReady()");
    EasyLoading.show(status: "获取中...");
    Log.d("HomeController--onInit()");
    state.userProfile = await UserStore.to.getProfile();
    // getMouldTaskList();
    // getInventoryList();

    getInventoryFinishedList(1);
  }

  @override
  void onClose() {
    Log.d("HomeController--onClose()");
  }
}
