import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/apis/mould_task_api.dart';
import 'package:inventory_app/app/modules/home/HomeState.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/utils/logger.dart';

import '../../../entity/mould_bind.dart';

class HomeController extends GetxController {
  ///响应式变量
  final state = HomeState();

  ///获取模具绑定列表
  getMouldTaskList() async {
    state.mouldBindTaskList =
        await MouldTaskApi.getMouldTaskList(CommonUtils.getCommonParams());
  }

  /// 获取资产盘点列表
  getInventoryList() async {
    state.inventoryList =
        await InventoryApi.getInventoryList(CommonUtils.getCommonParams());
  }

  ///根据模具任务状态 获取对应集合数据
  List<MouldList> mouldBindTaskListForWaitBind(int position, int status) {
    return state
            .mouldBindTaskList.data?.unfinishedTaskList?[position]?.mouldList
            ?.where((element) => element.bindStatus == status)
            ?.toList() ??
        List.empty();
  }

  /**根据传入的类型及关键字查询模具列表
   * @param taskNo  任务编号
   * @param key 输入框关键字
   * @param bindStatus  绑定状态  支持多选查询
   * @param  toolingType  工业状态  支持多选查询
   */

  getMouldTaskListByKeyOrStatus(String taskNo, String key, List<int> bindStatus,
      List<String> toolingType) async {
    state.mouldBindTaskListSearch = await state
        .mouldBindTaskList.value?.data?.unfinishedTaskList
        ?.where((element) => element.taskNo == taskNo);
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
