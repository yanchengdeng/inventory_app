import 'dart:collection';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/values/constants.dart';

import '../../../entity/InventoryData.dart';
import '../../../utils/logger.dart';
import '../../../widgets/toast.dart';
import '../../home/controllers/home_controller.dart';

class InventoryTasklistSubLevelController extends GetxController {
  ///资产盘点搜索列表

  var _inventoryTaskSearch = RxList<InventoryDetail?>(List.empty());

  set inventoryTaskSearch(value) => _inventoryTaskSearch.value = value;

  get inventoryTaskSearch => _inventoryTaskSearch.value;

  final homeController = Get.find<HomeController>();

  var taskNo = '';

  ///查找查询数据
  findByParams(isFinish, String taskNo, String key, List<int> bindStatus,
      List<String> toolingType) async {
    this.taskNo = taskNo;
    if (isFinish) {
      var task = homeController.inventoryFinishedList
          ?.where((element) => element.taskNo == taskNo)
          ?.first;
      var mouldList = task?.list;
      inventoryTaskSearch = mouldList;
    } else {
      inventoryTaskSearch = await homeController.inventoryList.value.data
              ?.where((element) => element.taskNo == this.taskNo)
              .first
              .list ??
          List.empty();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  @override
  void refresh() {
    super.refresh();

    ///强制清空再取  达到强制刷新效果
    _inventoryTaskSearch.value = List.empty();
    _inventoryTaskSearch.value = homeController.inventoryList.value.data
            ?.where((element) => element.taskNo == this.taskNo)
            .first
            .list ??
        List.empty();

    inventoryTaskSearch.forEach((element) {
      Log.d("刷新的盘点数据：${element?.toJson()}");
    });
  }

  ///上传盘点任务
  void upload() async {
    List<InventoryDetail?> waitForInventorys = _inventoryTaskSearch.value
        .where((element) =>
            element?.assetInventoryStatus == INVENTORY_WAITING_UPLOAD)
        .toList();

    if (waitForInventorys.isNotEmpty) {
      EasyLoading.show(status: '上传中...');
      waitForInventorys.forEach((element) {
        uploadSingleInventory(element);
      });
    } else {
      toastInfo(msg: '当前无待上传状态的模具可上传');
    }
  }

/**
 * 根据盘点详情id上传盘点数据，特别的，如果message返回-1和-2需要做APP端做特殊处理。
 * -1：模具所在的盘点单是否需要盘点，如果不需要此供应商盘点，列表页也不再加载此盘点单，从缓存中删除，并提示：xxxx（盘点编号）已从任务中移除模具所在的盘点单是否已经取消，
 * -2：如果盘点状态为已取消，列表页也不再加载此盘点单，从缓存中删除，
 * 提示：xxxx（盘点编号）已从任务中移除。其中xxxx，需要把盘点列表的inventoryTaskId一路带到上传界面，以支持此场景
 */
  ///单个盘点任务上传
  void uploadSingleInventory(InventoryDetail? element) async {
    if (element?.labelNo?.isEmpty == true) {
      toastInfo(msg: '该数据无任何标签');
      return;
    }
    var jsonMaps = HashMap();
    jsonMaps['address'] = element?.address;
    jsonMaps['bindLabel'] = element?.labelNo?.split(',')[0];
    jsonMaps['inventoryDetailId'] = element?.assetInventoryDetailId;
    jsonMaps['lat'] = element?.lat;
    jsonMaps['lng'] = element?.lng;

    int resultCode =
        await InventoryApi.uploadInventoryTask(jsonEncode(jsonMaps));
    if (resultCode == API_RESPONSE_OK) {
      element?.assetInventoryStatus = INVENTORY_HAVE_UPLOADED;

      List<InventoryDetail?>? allFinished = homeController
          .inventoryList.value.data
          ?.where((elementItem) => elementItem.taskNo == this.taskNo)
          .first
          .list
          ?.where((element2) =>
              element2.assetInventoryStatus == INVENTORY_HAVE_UPLOADED)
          .toList();
      Log.d(
          "绑定任务都已上传 ，现在${homeController.inventoryList.value.data?.length}个任务");
      if (homeController.inventoryList.value.data
              ?.where((elementItem) => elementItem.taskNo == this.taskNo)
              .first
              .list
              ?.length ==
          allFinished?.length) {
        ///已完成和总数形同则删除该任务

        homeController.inventoryList.value.data
            ?.removeWhere((element) => element.taskNo == this.taskNo);

        CacheUtils.to
            .saveInventoryTask(homeController.inventoryList.value, true);

        Log.e(
            "该任务下都已经上传 ，删除该模具任务现在还有${homeController.inventoryList.value.data?.length}个任务");

        ///返回到上一页
        Get.back();
      } else if (resultCode == -1) {
        toastInfo(msg: '${element?.assetNo}已从任务中移除模具所在的盘点单');
        homeController.inventoryList.value.data
            ?.where((element) => element.taskNo == this.taskNo)
            .first
            .list
            ?.removeWhere((element1) => element1.assetNo == element?.assetNo);

        CacheUtils.to
            .saveInventoryTask(homeController.inventoryList.value, true);
      } else if (resultCode == -2) {
        toastInfo(msg: '${element?.assetNo}已从任务中移除模具所在的盘点单');

        homeController.inventoryList.value.data
            ?.where((element) => element.taskNo == this.taskNo)
            .first
            .list
            ?.removeWhere((element1) => element1.assetNo == element?.assetNo);

        CacheUtils.to
            .saveInventoryTask(homeController.inventoryList.value, true);
      } else {
        List<InventoryDetail> originTasks = await homeController
                .inventoryList.value.data
                ?.where((element) => element.taskNo == this.taskNo)
                .first
                .list ??
            List.empty();

        inventoryTaskSearch = originTasks;

        CacheUtils.to
            .saveInventoryTask(homeController.inventoryList.value, true);
      }
    }
  }
}
