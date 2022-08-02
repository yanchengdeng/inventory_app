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
import '../../../utils/cache.dart';

class HomeController extends GetxController {
  ///响应式变量
  final state = HomeState();

  ///获取模具绑定列表
  getMouldTaskList() async {
    MouldBindList mouldBindList =
        await MouldTaskApi.getMouldTaskList(CommonUtils.getCommonParams());
    await CacheUtils.to.saveMouldTask(mouldBindList.data);
  }

  /// 获取资产盘点列表
  getInventoryList() async {
    InventoryList inventoryList =
    await InventoryApi.getInventoryList(CommonUtils.getCommonParams());
    await CacheUtils.to.saveInventoryTask(inventoryList.data);
  }

  @override
  void onInit() {
    super.onInit();
    EasyLoading.show(status: "获取中...");
    Log.d("HomeController--onInit()");
    getMouldTaskList();
    getInventoryList();
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
