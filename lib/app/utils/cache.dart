import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/services/services.dart';
import 'package:inventory_app/app/store/store.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';
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
支付任务绑定 assetBindTaskId  只比对id
标签替换任务 labelReplaceTaskId  如果相同 哈需要比对 下发时间，如果下发时间不一致则删除本地 取网络
盘点任务  assetInventoryDetailId   同标签绑定任务一样，需要验证下发时间是否一致

    代码逻辑：
    1.  第一级任务列表 taskNo  取 并集  如果并集在缓存中，则使用缓存，没在则添加服务下发tasK进入缓存（新任务）
2.第二级 子任务 ：
 支付任务标签  assetBindTaskId 取并集 只比对id  缓存有使用缓存 没有使用服务下发
 标签替换和盘点  除了比对id  还需要对比下发时间 


@param: data  网络数据
@param : isLocalSave 是否本地修改保存


   */

  Future<void> saveMouldTask(MouldBindTask? data, bool isLocalSave) async {
    final HomeController homeController = Get.find<HomeController>();

    /// 网络原始数据获取后  需要保存两个临时变量
    if (data != null && data.data != null && data.data?.length != 0) {
      ///设置下发的数据 缓存状态 bindStatusPre 为默认的bindStatus
      ///设置下发数据  读取标签的状态 labelTypePre 为默认的labelType  当标签清除时 标签类型恢复至原始状态
      if (!isLocalSave) {
        data.data?.forEach((element) {
          element.mouldList?.forEach((element) {
            if (element.bindStatus == BIND_STATUS_REBIND ||
                element.bindStatus == BIND_STATUS_WAITING_BIND) {
              element.bindStatusPre = element.bindStatus;
            }
            element.labelTypePre = element.labelType;
          });
        });
      }

      ///无该用户数据 直接保存 ,本地修改 直接保存
      var cahcheData = StorageService.to.getString(getMouldSaveKey());
      if (cahcheData.isEmpty || isLocalSave) {
        homeController.mouldBindList.value = data;
        StorageService.to.setString(getMouldSaveKey(), jsonEncode(data));
      } else {
        /// 服务端下发的taskNos
        List<String?>? netTaskNos = data.data?.map((e) => e.taskNo).toList();

        if (netTaskNos == null || netTaskNos.length == 0) {
          ///网络无任务 则全部删除
          homeController.mouldBindList.value = MouldBindTask();
          StorageService.to.setString(getMouldSaveKey(), "");
        } else {
          homeController.mouldBindList.value = await getMouldTask();

          /// 本地缓存taskNos
          List<String?>? cacheTaskNos = homeController.mouldBindList.value.data
              ?.map((e) => e.taskNo)
              .toList();

          ///服务端下有下发taskNo  本地没有taskNo  则本地添加
          List<MouldTaskItem> extraNetTaskNos = data.data
                  ?.where((element) =>
                      cacheTaskNos?.contains(element.taskNo) == false)
                  .toList() ??
              List.empty();
          homeController.mouldBindList.value.data
              ?.addAllIf(extraNetTaskNos.isNotEmpty, extraNetTaskNos);

          ///本地有taskNo  服务端没有taskNo  则 删除本地taskNo
          homeController.mouldBindList.value.data
              ?.removeWhere((element) => !netTaskNos.contains(element.taskNo));

          ///第二级 子任务 ：
          ///  支付任务标签  assetBindTaskId 取并集 只比对id  缓存有使用缓存 没有使用服务下发
          ///标签替换和盘点  除了比对id  还需要对比下发时间
          ///
          ///
          ///  以服务端下发的id 为准
          ///先取出服务下发的所有的
          /// 标签任务 比对id  如果下发时间不一致 则取服务端下发的id
          List<MouldList> mouldListsLabelsFromNet = [];

          ///支付绑定任务  只需要比对 id
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

          ///////////////////////////支付任务标签替换规则： 只比对assetBindTaskId ： 本地有 服务端无则删除  本地无 服务端有则添加 ，其他不变 ///////////////////////////////////////////////////
          mouldListsPaysFromNet.forEach((payLabel) {
            var mouldList = homeController.mouldBindList.value.data
                ?.where((element) => element.taskNo == payLabel.taskNo)
                .first
                .mouldList;

            ///删除本地支付标签id   不在网路下发中的
            mouldList?.removeWhere((mouldItem) => !mouldListsPaysFromNet
                .map((e) => e.assetBindTaskId)
                .contains(mouldItem.assetBindTaskId));

            /// 是否存在  ：本地不存在  服务有下发的id任务
            var extraPayLabel = mouldList
                ?.map((e) => e.assetBindTaskId)
                .contains(payLabel.assetBindTaskId);

            ///本地未包该服务下发的支付任务  则添加到本地缓存
            if (extraPayLabel == false) {
              mouldList?.add(payLabel);
            }
          });

          ///////////////标签替换任务替换规则：  比对：labelReplaceTaskId 如果 id 相同，再比对下发时间 ，下发时间不同则用服务端取代本地//////////////////
          mouldListsLabelsFromNet.forEach((repalceLabel) {
            var mouldList = homeController.mouldBindList.value.data
                ?.where((element) => element.taskNo == repalceLabel.taskNo)
                .first
                .mouldList;

            ///本地不存在服务下发的标签id   删除本地标签id
            mouldList?.removeWhere((element) => !mouldListsLabelsFromNet
                .map((e) => e.labelReplaceTaskId)
                .contains(element.labelReplaceTaskId));

            /// 添加网路存在标签id  本地不存在
            var existLabelReplace = mouldList
                ?.map((e) => e.labelReplaceTaskId)
                .contains(repalceLabel.labelReplaceTaskId);

            ///不存在 添加
            if (existLabelReplace == false) {
              mouldList?.add(repalceLabel);
            } else {
              ///存在  则比对下发时间
              var distributionTimeCache = mouldList
                  ?.where((element) =>
                      element.labelReplaceTaskId ==
                      repalceLabel.labelReplaceTaskId)
                  .first
                  .distributionTime;

              if (distributionTimeCache != repalceLabel.distributionTime) {
                ///时间不同则  服务下发 替换本地
                mouldList?.removeWhere((element) =>
                    element.labelReplaceTaskId ==
                    repalceLabel.labelReplaceTaskId);

                mouldList?.add(repalceLabel);
              }
            }
          });
        }

        ///排序 按下发时间倒序
        homeController.mouldBindList.value.data?.sort((a, b) =>
            (b.distributionTimeStamp ?? 0)
                .compareTo(a.distributionTimeStamp ?? 0));

        StorageService.to.setString(
            getMouldSaveKey(), jsonEncode(homeController.mouldBindList.value));
      }
    } else {
      await StorageService.to.setString(getMouldSaveKey(), '');
      homeController.mouldBindList.value = MouldBindTask();
    }
  }

  /// 获取本地保存的模具绑定任务
  Future<MouldBindTask> getMouldTask() async {
    var cacheMould = await StorageService.to.getString(getMouldSaveKey());
    if (cacheMould.isNotEmpty) {
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

  /**
   * isLocalSave :  是否来自本地保存
   * data : 服务下发数据
   * 对比流程参考  支付任务替换
   * 
   */
  Future<void> saveInventoryTask(InventoryData? data, bool isLocalSave) async {
    final HomeController homeController = Get.find<HomeController>();

    ///todo 网络获取 本地存在需要对比保存
    if (data != null && data.data != null && data.data?.length != 0) {
      ///本地无数据 直接添加进缓存
      var cacheData = StorageService.to.getString(getInventorySaveKey());
      if (cacheData.isEmpty || isLocalSave) {
        homeController.inventoryList.value = data;
        StorageService.to.setString(getInventorySaveKey(), jsonEncode(data));
      } else {
        /// 服务端下发的taskNos
        List<String?>? netTaskNos = data.data?.map((e) => e.taskNo).toList();

        if (netTaskNos == null || netTaskNos.length == 0) {
          homeController.inventoryList.value = InventoryData();
          StorageService.to.setString(getInventorySaveKey(), '');
        } else {
          homeController.inventoryList.value = await getInventoryTask();

          /// 本地缓存taskNos
          List<String?>? cacheTaskNos = homeController.inventoryList.value.data
              ?.map((e) => e.taskNo)
              .toList();

          ///服务端下有下发taskNo  本地没有taskNo  则本地添加
          List<InventoryFinishedList> extraNetTaskNos = data.data
                  ?.where((element) =>
                      cacheTaskNos?.contains(element.taskNo) == false)
                  .toList() ??
              List.empty();
          homeController.inventoryList.value.data
              ?.addAllIf(extraNetTaskNos.isNotEmpty, extraNetTaskNos);

          ///本地有taskNo  服务端没有taskNo  则 删除本地taskNo
          homeController.inventoryList.value.data
              ?.removeWhere((element) => !netTaskNos.contains(element.taskNo));

          ///第二级 子任务 ：
          /// 盘点任务 参考   支付绑定任务替换规则
          ///
          ///  以服务端下发的id 为准
          ///先取出服务下发的所有的

          ///盘点任务 只比对 assetInventoryDetailId
          List<InventoryDetail> inventoryDetailsFromNet = [];
          data.data?.forEach((taskElement) {
            taskElement.list?.forEach((elementItem) {
              inventoryDetailsFromNet.add(elementItem);
            });
          });

          ///////////////////////////盘点任务签替换规则： 只比对assetInventoryDetailId： 本地有 服务端无则删除  本地无 服务端有则添加 ，其他不变 ///////////////////////////////////////////////////
          inventoryDetailsFromNet.forEach((inventoryDetail) {
            var inventoryList = homeController.inventoryList.value.data
                ?.where(
                    (element) => element.taskNo == inventoryDetail.inventoryNo)
                .first
                .list;

            ///删除本地支付标签id   不在网路下发中的
            inventoryList?.removeWhere((inventoryItem) =>
                !inventoryDetailsFromNet
                    .map((e) => e.assetInventoryDetailId)
                    .contains(inventoryItem.assetInventoryDetailId));

            /// 是否存在  ：本地不存在  服务有下发的id任务
            var extraPayLabel = inventoryList
                ?.map((e) => e.assetInventoryDetailId)
                .contains(inventoryDetail.assetInventoryDetailId);

            ///本地未包该服务下发的支付任务  则添加到本地缓存
            if (extraPayLabel == false) {
              inventoryList?.add(inventoryDetail);
            }
          });

          ///排序 按下发时间倒序
          homeController.inventoryList.value.data?.sort((a, b) =>
              (b.distributionTimeStamp ?? 0)
                  .compareTo(a.distributionTimeStamp ?? 0));

          saveInventoryTask(homeController.inventoryList.value, true);
        }
      }
    } else {
      await StorageService.to.setString(getInventorySaveKey(), '');
      homeController.inventoryList.value = InventoryData();
    }
  }

  /// 获取本地的盘点任务
  Future<InventoryData> getInventoryTask() async {
    var cacheMould = await StorageService.to.getString(getInventorySaveKey());
    if (cacheMould.isNotEmpty) {
      return InventoryData.fromJson(jsonDecode(cacheMould));
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
