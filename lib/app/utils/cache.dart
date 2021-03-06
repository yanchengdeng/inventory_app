import 'dart:collection';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inventory_app/app/services/services.dart';
import 'package:inventory_app/app/utils/utils.dart';

import '../entity/cache_data.dart';
import '../entity/inventory_list.dart';
import '../entity/mould_bind.dart';
import '../values/storage.dart';

/**
 * 缓存跟着账号走  和产品确认账号的来源？？？
 * 本地缓存数据工具
 */

class CacheUtils extends GetxController {
  static CacheUtils get to => Get.find();

  ///模具绑定信息
  var _mouldBindTaskList = Rx<MouldData?>(null);

  set mouldBindTaskList(value) => _mouldBindTaskList.value = value;

  get mouldBindTaskList => _mouldBindTaskList.value;

  /// 磨具绑定搜索关键字
  var _mouldSearchKey = RxString("");

  set mouldSearchKey(value) => _mouldSearchKey.value = value;

  get mouldSearchKey => _mouldSearchKey.value;

  ///模具绑定搜索列表
  var _mouldBindTaskListSearch = Rx<MouldFinishedTaskList?>(null);

  set mouldBindTaskListSearch(value) => _mouldBindTaskListSearch.value = value;

  get mouldBindTaskListSearch => _mouldBindTaskListSearch.value;

  ///模具资产信息
  var _assertBindTaskInfo = Rx<MouldList?>(null);

  set assertBindTaskInfo(value) => _assertBindTaskInfo.value = value;

  get assertBindTaskInfo => _assertBindTaskInfo.value;

  /// todo  假设用户  001
  static const String USER_CODE = '0001';

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
  Future<void> saveMouldTask(MouldData? data) async {
    var cacheMould = await StorageService.to.getString(STORAGE_TASK_MOULD_DATA);
    _mouldBindTaskList.value = data;
    if (cacheMould.isEmpty) {
      List<CacheMouldBindData> list = [
        CacheMouldBindData(userId: USER_CODE, data: data)
      ];

      ///首次保存
      await StorageService.to
          .setString(STORAGE_TASK_MOULD_DATA, json.encode(list));
    } else {
      ///TODO  对比保存 待确定

    }
  }

  /// 获取下发的模具绑定任务
  Future<void> getMouldTask() async {
    var cacheMould = await StorageService.to.getString(STORAGE_TASK_MOULD_DATA);
    if (cacheMould.isNotEmpty) {
      final List<dynamic> cacheMouldBindData = jsonDecode(cacheMould);

      var _InternalLinkedHashMap = cacheMouldBindData
          .where((element) => element['userId'] == USER_CODE)
          .first;

      CacheMouldBindData bindData =
          CacheMouldBindData.fromJson(_InternalLinkedHashMap);

      _mouldBindTaskList.value = bindData.data!;

      Log.d(
          "本地模具解析成功：${cacheMouldBindData.length}---${bindData.data?.finished}");
    } else {
      Log.d("未找到模具数据，请检查网络数据");
    }
  }

  ///根据模具任务状态 获取对应集合数据
  List<MouldList> mouldBindTaskListForWaitBind(int position, int status) {
    return mouldBindTaskList.unfinishedTaskList?[position]?.mouldList
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

  Future<void> getMouldTaskListByKeyOrStatus(bool isFinish, String taskNo,
      String key, List<int> bindStatus, List<String> toolingType) async {
    await getMouldTask();

    mouldBindTaskListSearch = await (isFinish
            ? mouldBindTaskList.finishedTaskList
            : mouldBindTaskList.unfinishedTaskList)
        .where((element) => element.taskNo == taskNo)
        .first;
  }

  /**
   * 已上传的
   * 根据传入的资产编号获取资产编号信息
   */
  Future<void> getAssetBindTaskInfo(String taskNo, String assetNo) async {
    await getMouldTask();
    var task = await mouldBindTaskList.finishedTaskList
        ?.where((element) => element.taskNo == taskNo)
        .first;
    var mouldList = task?.mouldList;

    _assertBindTaskInfo.value =
        await mouldList?.where((element) => element.assetNo == assetNo).first;

    Log.d("${_assertBindTaskInfo.value}");
  }

  /**
   * 其他未上传状态（可编辑）
   * 根据传入的资产编号获取资产编号信息
   */
  Future<void> getUnLoadedAssetBindTaskInfo(
      String taskNo, String assetNo) async {
    await getMouldTask();
    var task = mouldBindTaskList.unfinishedTaskList
        ?.where((element) => element.taskNo == taskNo)
        ?.first;
    var mouldList = task?.mouldList;
    _assertBindTaskInfo.value =
        mouldList?.where((element) => element.assetNo == assetNo)?.first;

    Log.d("${_assertBindTaskInfo.value}");
  }

  ////////////////////////////////以下为资产盘点数据操作//////////////////////////////////////////////

  ///资产盘点信息
  var _inventoryList = Rx<InventroyData?>(null);

  set inventoryList(value) => _inventoryList.value = value;

  get inventoryList => _inventoryList.value;

  /// 盘点搜索关键字
  var _inventroySearchKey = RxString("");

  set inventroySearchKey(value) => _inventroySearchKey.value = value;

  get inventroySearchKey => _inventroySearchKey.value;

  ///资产盘点搜索列表
  var _inventoryTaskListSearch = Rx<InventoryFinishedList?>(null);

  set inventoryTaskListSearch(value) => _inventoryTaskListSearch.value = value;

  get inventoryTaskListSearch => _inventoryTaskListSearch.value;

/**
 * 本地有和服务端的相同的 assetBindTaskId\labelReplaceTaskId\assetInventoryDetailId 
这些id 则用本地缓存的（缓存信息里包含用户操作数据，比服务端丰富），没有这些id 则视为新增的id任务

本地没有 服务器有，  本地增加
本地有   服务器没有， 本地删除
服务器和本地都有的情况下比对下发时间DISTRIBUTION_DATE：下发时间一致，不动；下发时间不一致，清空对应模具信息再缓存
因为替换和盘点的labelReplaceTaskId\assetInventoryDetailId  和绑定的assetBindTaskId不一样，相同模具重复下发时的ID是不变的，
需要借助下发时间做进一步判断是否需要删除缓存
 */
  Future<void> saveInventoryTask(InventroyData? data) async {
    var cacheMould = await StorageService.to.getString(STORAGE_INVENTORY_DATA);
    _inventoryList.value = data;
    if (cacheMould.isEmpty) {
      List<CacheInventoryData> list = [
        CacheInventoryData(userId: USER_CODE, data: data)
      ];

      ///首次保存
      await StorageService.to
          .setString(STORAGE_INVENTORY_DATA, json.encode(list));
    } else {
      ///TODO  对比保存 待确定

    }
  }

  /// 获取本地的盘点任务
  Future<void> getInventoryTask() async {
    var cacheMould = await StorageService.to.getString(STORAGE_INVENTORY_DATA);
    if (cacheMould.isNotEmpty) {
      final List<dynamic> cacheMouldBindData = jsonDecode(cacheMould);

      var _InternalLinkedHashMap = cacheMouldBindData
          .where((element) => element['userId'] == USER_CODE)
          .first;

      CacheInventoryData bindData =
          CacheInventoryData.fromJson(_InternalLinkedHashMap);

      _inventoryList.value = bindData.data!;

      Log.d(
          "本地盘点任务 解析成功：${cacheMouldBindData.length}---${bindData.data?.finished}");
    } else {
      Log.d("未找到盘点数据，请检查网络数据");
    }
  }

  ///根据模具任务状态 获取对应集合数据
  List<ItemList> getInventoryListByStatus(int position, int status) {
    return inventoryList.unfinishedList?[position]?.list
            ?.where((element) => element.assetInventoryStatus == status)
            ?.toList() ??
        List.empty();
  }

  /**根据传入的类型及关键字查询资产盘点列表
   * @param taskNo  任务编号
   * @param key 输入框关键字
   * @param bindStatus  绑定状态  支持多选查询
   * @param  toolingType  工业状态  支持多选查询
   */

  Future<void> getInventoryTaskListByKeyOrStatus(bool isFinish, String taskNo,
      String key, List<int> bindStatus, List<String> toolingType) async {
    await getInventoryTask();

    inventoryTaskListSearch = await (isFinish
            ? inventoryList.finishedList
            : inventoryList.unfinishedList)
        .where((element) => element.taskNo == taskNo)
        .first;
  }
}
