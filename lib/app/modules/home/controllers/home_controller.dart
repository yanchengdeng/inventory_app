import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/entity/UserInfo.dart';
import 'package:inventory_app/app/modules/home/HomeState.dart';
import 'package:inventory_app/app/utils/common.dart';
import '../../../entity/InventoryData.dart';
import '../../../entity/MouldBindTask.dart';
import '../../../store/user.dart';
import '../../../utils/cache.dart';
import '../../../values/constants.dart';
import '../../../values/server.dart';
import '../../../widgets/toast.dart';

class HomeController extends GetxController {
  ///响应式变量
  final state = HomeState();

  var mouldBindList = MouldBindTask().obs;
  var inventoryList = InventoryData().obs;

  ///获取未完成模具绑定列表
  getMouldTaskList() async {
    mouldBindList.value = await MouldTaskApi.getMouldTaskList();
    if (mouldBindList.value.state == API_RESPONSE_OK ) {
      await CacheUtils.to.saveMouldTask(mouldBindList.value, false);
    } else {
      mouldBindList.value = await CacheUtils.to.getMouldTask();
    }
  }

  /// 获取未完成资产盘点列表
  getInventoryList() async {
    inventoryList.value = await InventoryApi.getInventoryData();
    if (inventoryList.value.state == API_RESPONSE_OK &&
        inventoryList.value.data?.isNotEmpty == true) {
      await CacheUtils.to.saveInventoryTask(inventoryList.value, false);
    } else {
      inventoryList.value = await CacheUtils.to.getInventoryTask();
    }
  }

  ///已完成的盘点任务
  var _inventoryFinishedList = RxList<InventoryFinishedList?>(List.empty());

  set inventoryFinishedList(value) => _inventoryFinishedList.value = value;

  get inventoryFinishedList => _inventoryFinishedList.value;

  /// 获取已完成的资产盘点列表
  Future<InventoryData> getInventoryFinishedList(int page) async {
    InventoryData inventoryList =
        await InventoryApi.getInventoryFinishedList(page);

    if (inventoryList.data?.isNotEmpty ?? false) {
      if (page == 0) {
        _inventoryFinishedList.clear();
      }
      _inventoryFinishedList.addAll(inventoryList.data ?? List.empty());
    }
    return inventoryList;
  }

  ///已完成的模具任务
  var _mouldTaskFinishedList = RxList<MouldTaskItem>(List.empty());

  set mouldTaskFinishedList(value) => _mouldTaskFinishedList.value = value;

  get mouldTaskFinishedList => _mouldTaskFinishedList.value;

  /// 获取已完成的模具任务列表
  Future<MouldBindTask> getMouldTaskFinishedList(int page) async {
    MouldBindTask mouldBindList =
        await MouldTaskApi.getMouldBindListFinishedList(page);

    if (mouldBindList.data?.isNotEmpty == true) {
      if (page == 0) {
        _mouldTaskFinishedList.clear();
      }
      _mouldTaskFinishedList.addAll(mouldBindList.data ?? List.empty());
    }
    return mouldBindList;
  }

  @override
  void onInit() async {
    super.onInit();
    EasyLoading.show(status: "获取中...");
    if (SERVER_ENV == Environment.SIT) {
      ///SIT环境   x-user-code  不是必须参数
      getMouldTaskList();
      getInventoryList();
    } else {
      ///开发环境   x-user-code  是必须参数
      var userResponseData = await UserStore.to.getProfile();
      if (userResponseData?.state == API_RESPONSE_OK &&
          userResponseData?.data != null) {
        state.userData.value = userResponseData?.data ?? UserData();
        getMouldTaskList();
        getInventoryList();
      } else {
        CommonUtils.logOut();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
