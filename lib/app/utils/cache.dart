import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
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
      因为替换和盘点的labelReplaceTaskId\assetInventoryDetailId  
      和绑定的assetBindTaskId不一样，相同模具重复下发时的ID是不变的，
      需要借助下发时间做进一步判断是否需要删除缓存
   */

  Future<void> saveMouldTask(MouldBindTask? data, bool isLocalSave) async {
    final HomeController homeController = Get.find<HomeController>();

    ///无该用户数据 直接保存 ,本地修改 直接保存
    if (StorageService.to.getString(getMouldSaveKey()).isEmpty || isLocalSave) {
      homeController.mouldBindList.value = data ?? MouldBindTask();
      StorageService.to.setString(getMouldSaveKey(), jsonEncode(data));
    } else {
      ///todo 网络获取 本地存在需要对比保存
      if (data != null && data.data?.isNotEmpty == true) {
        // ///本地数据
        // homeController.mouldBindList.value = data;
        // ////网络数据
        // data;
        //
        // for (var task in data.data ?? List.empty()) {
        //   Log.d("task 对比：${task['taskNo']}");
        // }

        // for (var taskCache
        //     in homeController.mouldBindList.value.data ?? List.empty()) {
        //   Log.d("taskCache========== 对比${taskCache['taskNo']}");
        // }

        /// 服务端下有下发taskNo  本地没有taskNo  则本地添加
        List<String?>? cacheTasks = homeController.mouldBindList.value.data
            ?.map((e) => e.taskNo)
            .toList();
        if (cacheTasks?.isNotEmpty == true) {
          var mouldTaskItems = data.data?.where(
              (element) => cacheTasks?.contains(element.taskNo) == false);
          if (mouldTaskItems != null && mouldTaskItems.isNotEmpty) {
            homeController.mouldBindList.value.data?.addAll(mouldTaskItems);
          }
        }

        /// 本地有taskNo  服务端没有taskNo  则 删除本地taskNo
        List<String?>? netTasks = data.data?.map((e) => e.taskNo).toList();
        var localTaskItems = homeController.mouldBindList.value.data
            ?.where((element) => netTasks?.contains(element.taskNo) == false);

        localTaskItems?.forEach((element) {
          homeController.mouldBindList.value.data?.remove(element);
        });

        ///如果是相同的taskNo 下的任务
        ///则比对 labelReplaceTaskId  和下发时间 一起判断  ： 相同labelReplaceTaskId  下发时间不一致则用服务端取代本地
        ///assetBindTaskId  支付任务绑定    不需要下发时间来判断是否缓存
        ///
        ///
        ///
        ///
        ///先取出服务下发的所有的 标签任务和
        List<MouldList> mouldListsLabelsFromNet = [];

        ///支付绑定任务
        List<MouldList> mouldListsPaysFromNet = [];
        data.data?.forEach((taskElement) {
          taskElement.mouldList?.forEach((elementItem) {
            if (elementItem.labelReplaceTaskId! > 0 &&
                taskElement.taskType == MOULD_TASK_TYPE_LABEL) {
              mouldListsLabelsFromNet.add(elementItem);
            }

            if (elementItem.assetBindTaskId! > 0 &&
                taskElement.taskType == MOULD_TASK_TYPE_PAY) {
              mouldListsPaysFromNet.add(elementItem);
            }
          });
        });

        ///开始对比 服务端有任务id 本地没有则本地删除，本地有  服务端没有 则本地删除
        // mouldListsLabelsFromNet.forEach((elementLable) {
        //   homeController.mouldBindList.value.data
        //       ?.where((element1) => element1.taskNo == elementLable.taskNo)
        //       .first
        //       .mouldList
        //       ?.addIf(, elementLable);
        // });

        //  homeController.mouldBindList.value = data;
        // StorageService.to.setString(getMouldSaveKey(), jsonEncode(data));

      } else {
        homeController.mouldBindList.value = MouldBindTask();
      }
    }
  }

  /// 获取本地保存的模具绑定任务
  Future<MouldBindTask> getMouldTask() async {
    var cacheMould = await StorageService.to.getString(getMouldSaveKey());
    if (cacheMould.isNotEmpty) {
      Log.d("转移1${jsonDecode(cacheMould) is Map}");
      return MouldBindTask.fromJson(jsonDecode(cacheMould));
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
    final HomeController homeController = Get.find<HomeController>();
    var listSearch = homeController.mouldBindList.value.data
        ?.where((element) => element.taskNo == taskNo)
        .first
        .mouldList
        ?.where((it) =>
            bindStatus.contains(it.bindStatus) &&
            toolingTypes.contains(it.toolingType) &&
            it.assetNo?.contains(key) == true)
        .toList();
    return listSearch ?? List.empty();
  }

  ////////////////////////////////以下为资产盘点数据操作//////////////////////////////////////////////

  ///资产盘点未完成信息
  var inventoryData = InventoryData().obs;

  /**
   * isLocalSave :  是否来自本地保存
   * 
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
      inventoryData.value = data ?? await getInventoryTask();
    }
  }

  /// 获取本地的盘点任务
  Future<InventoryData> getInventoryTask() async {
    var cacheMould = await StorageService.to.getString(getInventorySaveKey());
    if (cacheMould.isNotEmpty) {
      inventoryData.value = InventoryData.fromJson(jsonDecode(cacheMould));
      return inventoryData.value;
    } else {
      return InventoryData();
    }
  }

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
