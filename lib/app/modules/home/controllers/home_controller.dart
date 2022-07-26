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
      List<String> toolingType) {
    List<FinishedTaskList> unfinishedTaskList =
        state.mouldBindTaskList.data.unfinishedTaskList;
    state.mouldBindTaskListSearch =
        unfinishedTaskList.where((element) => element.taskNo == taskNo).first;
  }

  /**
   * 已上传的
   * 根据传入的资产编号获取资产编号信息
   */
  getAssetBindTaskInfo(String taskNo, String assetNo) {
    var task = state.mouldBindTaskList.data.finishedTaskList
        ?.where((element) => element.taskNo == taskNo)
        ?.first;

    var mouldList = task?.mouldList;

    state.assertBindTaskInfo =
        mouldList?.where((element) => element.assetNo == assetNo)?.first;
  }

  /**
   * 未上传的
   * 根据传入的资产编号获取资产编号信息
   */
  getUnLoadedAssetBindTaskInfo(String taskNo, String assetNo) {
    var task = state.mouldBindTaskList.data.unfinishedTaskList
        ?.where((element) => element.taskNo == taskNo)
        ?.first;

    var mouldList = task?.mouldList;

    state.assertBindTaskInfo =
        mouldList?.where((element) => element.assetNo == assetNo)?.first;
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
