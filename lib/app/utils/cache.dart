import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inventory_app/app/services/services.dart';
import 'package:inventory_app/app/store/store.dart';
import 'package:inventory_app/app/utils/utils.dart';

import '../entity/cache_data.dart';
import '../entity/inventory_list.dart';
import '../entity/mould_bind.dart';
import '../modules/home/controllers/home_controller.dart';
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

  String getUserCode() {
    return UserStore.to.userLoginResponseEntity?.data.userCode ?? '0001';
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

  Future<void> saveMouldTask(MouldData? data, bool isLocalSave) async {
    var cacheMould = await StorageService.to.getString(STORAGE_TASK_MOULD_DATA);
    if (cacheMould.isEmpty) {
      List<CacheMouldBindData> list = [
        CacheMouldBindData(userId: getUserCode(), data: data)
      ];
      await StorageService.to
          .setString(STORAGE_TASK_MOULD_DATA, json.encode(list));
    } else {
      ///TODO  对比保存 待确定  不同用户
      List list = json.decode(cacheMould);

      var itemList =
          list.where((element) => element['userId'] == getUserCode()).first;

//本地保存直接替换  、网络存储 有比对 无则保存
      if (isLocalSave) {
        if (itemList != null) {
          list.remove(itemList);
        }
        list.add(CacheMouldBindData(userId: getUserCode(), data: data));
      } else {
        if (itemList == null) {
          list.add(CacheMouldBindData(userId: getUserCode(), data: data));
        } else {
          //比对替换
        }
      }

      // CacheMouldBindData? existData =
      //     list?.where((element) => element.userId == getUserCode())?.first;
      // if (existData == null) {
      //   list.add(CacheMouldBindData(userId: getUserCode(), data: data));
      // }

      await StorageService.to
          .setString(STORAGE_TASK_MOULD_DATA, json.encode(list));
      Log.d("缓存信息${list.length}");
    }
    final homeController = Get.find<HomeController>();
    _mouldBindTaskList.value = data;
    homeController.setMouldData(data);
  }

  /// 获取下发的模具绑定任务
  Future<void> getMouldTask() async {
    var cacheMould = await StorageService.to.getString(STORAGE_TASK_MOULD_DATA);
    if (cacheMould.isNotEmpty) {
      final List<dynamic> cacheMouldBindData = jsonDecode(cacheMould);

      var _InternalLinkedHashMap = cacheMouldBindData
          .where((element) => element['userId'] == getUserCode())
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

  Future<List<MouldList?>> getMouldTaskListByKeyOrStatus(String taskNo,
      String key, List<int> bindStatus, List<String> toolingType) async {
    await getMouldTask();
    var unfinisedtask = await mouldBindTaskList.unfinishedTaskList
        .where((element) => element.taskNo == taskNo)
        ?.first;

    var mouldList = unfinisedtask?.mouldList;
    return mouldList;
  }

  /**
   * 其他未上传状态（可编辑）
   * 根据传入的资产编号获取资产编号信息
   */
  Future<MouldList> getUnLoadedAssetBindTaskInfo(
      String taskNo, String assetNo) async {
    await getMouldTask();
    var task = mouldBindTaskList.unfinishedTaskList
        ?.where((element) => element.taskNo == taskNo)
        ?.first;
    var mouldList = task?.mouldList;
    return mouldList?.where((element) => element.assetNo == assetNo)?.first;
  }

  ////////////////////////////////以下为资产盘点数据操作//////////////////////////////////////////////

  ///资产盘点未完成信息
  var _inventoryList = Rx<InventroyData?>(null);

  set inventoryList(value) => _inventoryList.value = value;

  get inventoryList => _inventoryList.value;

/**
 * 本地有和服务端的相同的 assetBindTaskId\labelReplaceTaskId\assetInventoryDetailId 
这些id 则用本地缓存的（缓存信息里包含用户操作数据，比服务端丰富），没有这些id 则视为新增的id任务

本地没有 服务器有，  本地增加
本地有   服务器没有， 本地删除
服务器和本地都有的情况下比对下发时间DISTRIBUTION_DATE：下发时间一致，不动；下发时间不一致，清空对应模具信息再缓存
因为替换和盘点的labelReplaceTaskId\assetInventoryDetailId  和绑定的assetBindTaskId不一样，相同模具重复下发时的ID是不变的，
需要借助下发时间做进一步判断是否需要删除缓存
 */
  Future<void> saveInventoryTask(InventroyData? data, bool isLocalSave) async {
    var cacheMould = await StorageService.to.getString(STORAGE_INVENTORY_DATA);
    _inventoryList.value = data;
    if (cacheMould.isEmpty) {
      List<CacheInventoryData> list = [
        CacheInventoryData(userId: getUserCode(), data: data)
      ];

      ///首次保存
      await StorageService.to
          .setString(STORAGE_INVENTORY_DATA, json.encode(list));
    } else {
      ///TODO  对比保存 待确定
      List list = json.decode(cacheMould);

      var itemList =
          list.where((element) => element['userId'] == getUserCode()).first;

      if (isLocalSave) {
        if (itemList != null) {
          list.remove(itemList);
        }
        list.add(CacheInventoryData(userId: getUserCode(), data: data));
      } else {
        if (itemList == null) {
          list.add(CacheInventoryData(userId: getUserCode(), data: data));
        } else {
          // 本地和网络 对比替换
        }
      }

      ///首次保存
      await StorageService.to
          .setString(STORAGE_INVENTORY_DATA, json.encode(list));
    }
  }

  /// 获取本地的盘点任务
  Future<void> getInventoryTask() async {
    var cacheMould = await StorageService.to.getString(STORAGE_INVENTORY_DATA);
    if (cacheMould.isNotEmpty) {
      final List<dynamic> cacheMouldBindData = jsonDecode(cacheMould);

      var _InternalLinkedHashMap = cacheMouldBindData
          .where((element) => element['userId'] == getUserCode())
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

  Future<List<ItemList>> getInventoryTaskListByKeyOrStatus(String taskNo,
      String key, List<int> bindStatus, List<String> toolingType) async {
    await getInventoryTask();

    var dataInfo = await inventoryList.unfinishedList
        .where((element) => element.taskNo == taskNo)
        .first;
    return dataInfo.list ?? List.empty();
  }
}
