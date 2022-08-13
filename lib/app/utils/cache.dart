import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventory_app/app/services/services.dart';
import 'package:inventory_app/app/store/store.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';

import '../entity/InventoryData.dart';
import '../entity/MouldBindTask.dart';

/**
 * 缓存跟着账号走  和产品确认账号的来源？？？
 * 本地缓存数据工具
 */

class CacheUtils extends GetxController {
  static CacheUtils get to => Get.find();

  ///模具绑定信息

  var mouldBindTask = MouldBindTask().obs;

  String getUserCode() {
    return UserStore.to.userData?.userCode ?? 'spl01';
  }

  ///获取模具绑定key
  String getMouldSaveKey() {
    return SAVE_KEY_FOR_MOULD + "_" + getUserCode();
  }

  ///获取盘点绑定key
  String getInventorySaveKey() {
    return SAVE_KEY_FOR_INVENTORY + "_" + getUserCode();
  }

  /**
   *
   * 本地有和服务端的相同的 assetBindTaskId\labelReplaceTaskId\assetInventoryDetailId
      这些id 则用本地缓存的（缓存信息里包含用户操作数据，比服务端丰富），没有这些id 则视为新增的id任务

      本地没有 服务器有，  本地增加
      本地有   服务器没有， 本地删除
      服务器和本地都有的情况下比对下发时间DISTRIBUTION_DATE：下发时间一致，不动；下发时间不一致，清空对应模具信息再缓存
      因为替换和盘点的labelReplaceTaskId\assetInventoryDetailId  和绑定的assetBindTaskId不一样，相同模具重复下发时的ID是不变的，
      需要借助下发时间做进一步判断是否需要删除缓存
   */

  Future<void> saveMouldTask(MouldBindTask? data, bool isLocalSave) async {
    ///无该用户数据 直接保存 ,本地修改 直接保存
    if (StorageService.to.getString(getMouldSaveKey()).isEmpty || isLocalSave) {
      mouldBindTask.value = data ?? MouldBindTask();
      StorageService.to.setString(getMouldSaveKey(), jsonEncode(data));
    } else {
      ///todo 网络获取 本地存在需要对比保存
      mouldBindTask.value = data ?? MouldBindTask();
    }
  }

  /// 获取下发的模具绑定任务
  Future<MouldBindTask> getMouldTask() async {
    var cacheMould = await StorageService.to.getString(getMouldSaveKey());
    if (cacheMould.isNotEmpty) {
      Log.d("转移1${jsonDecode(cacheMould) is Map}");

      mouldBindTask.value = MouldBindTask.fromJson(jsonDecode(cacheMould));
      return mouldBindTask.value;
    } else {
      return MouldBindTask();
    }
  }

  /**根据传入的类型及关键字查询模具列表
   * @param taskNo  任务编号
   * @param key 输入框关键字
   * @param bindStatus  绑定状态  支持多选查询
   * @param  toolingType  工业状态  支持多选查询
   */

  Future<List<MouldList>> getMouldTaskListByKeyOrStatus(String taskNo,
      String key, List<int> bindStatus, List<String> toolingTypes) async {
    var listSearch = mouldBindTask.value?.data
        ?.where((element) => element.taskNo == taskNo)
        ?.first
        ?.mouldList
        ?.where((it) =>
            bindStatus.contains(it.bindStatus) &&
            toolingTypes.contains(it.toolingType) &&
            it.assetNo?.contains(key) == true)
        .toList();
    return listSearch ?? List.empty();
  }

  ///更新模具任务
  updateMouldListState(String taskType, MouldList? mouldListItem) async {
    await getMouldTask();
  }

  ////////////////////////////////以下为资产盘点数据操作//////////////////////////////////////////////

  ///资产盘点未完成信息
  var inventoryData = InventoryData().obs;

  /**
   * 本地有和服务端的相同的 assetBindTaskId\labelReplaceTaskId\assetInventoryDetailId
      这些id 则用本地缓存的（缓存信息里包含用户操作数据，比服务端丰富），没有这些id 则视为新增的id任务

      本地没有 服务器有，  本地增加
      本地有   服务器没有， 本地删除
      服务器和本地都有的情况下比对下发时间DISTRIBUTION_DATE：下发时间一致，不动；下发时间不一致，清空对应模具信息再缓存
      因为替换和盘点的labelReplaceTaskId\assetInventoryDetailId  和绑定的assetBindTaskId不一样，相同模具重复下发时的ID是不变的，
      需要借助下发时间做进一步判断是否需要删除缓存
   */
  Future<void> saveInventoryTask(InventoryData? data, bool isLocalSave) async {
    ///无该用户数据 直接保存 ,本地修改 直接保存
    if (StorageService.to.getString(getInventorySaveKey()).isEmpty ||
        isLocalSave) {
      inventoryData.value = data ?? InventoryData();
      StorageService.to.setString(getInventorySaveKey(), jsonEncode(data));
    } else {
      ///todo 网络获取 本地存在需要对比保存
      inventoryData.value = data ?? InventoryData();
    }
  }

  /// 获取本地的盘点任务
  Future<void> getInventoryTask() async {}

  ///todo 根据模具任务状态 获取对应集合数据
  List<InventoryDetail> getInventoryListByStatus(int position, int status) {
    return List.empty();
  }

  /**根据传入的类型及关键字查询资产盘点列表
   * @param taskNo  任务编号
   * @param key 输入框关键字
   * @param bindStatus  绑定状态  支持多选查询
   * @param  toolingType  工业状态  支持多选查询
   */

  ///todo
  Future<List<InventoryDetail>> getInventoryTaskListByKeyOrStatus(String taskNo,
      String key, List<int> bindStatus, List<String> toolingType) async {
    ///todo
    return List.empty();
  }
}
