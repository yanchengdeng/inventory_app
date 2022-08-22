import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/utils/loading.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';
import '../../../entity/MouldBindTask.dart';
import '../../../utils/cache.dart';
import '../../../widgets/toast.dart';

class MouldBindMouldListController extends GetxController {
  ///模具绑定搜索列表
  var _mouldBindTaskListSearch = RxList<MouldList?>(List.empty());

  set mouldBindTaskListSearch(value) => _mouldBindTaskListSearch.value = value;

  get mouldBindTaskListSearch => _mouldBindTaskListSearch.value;

  final homeController = Get.find<HomeController>();

  var taskNo = "";

  ///todo  查询条件  查找查询数据
  /**
   * isFromFinish  来自已完成列表
   */
  findByParams(bool isFromFinish, String taskNo, String key,
      List<int> bindStatus, List<String> toolingType) async {
    this.taskNo = taskNo;

    if (isFromFinish) {
      _mouldBindTaskListSearch.value = homeController.mouldTaskFinishedList
              ?.where((element) => element.taskNo == taskNo)
              ?.first
              ?.mouldList
              ?.where((element) =>
                  (bindStatus.length > 0
                      ? bindStatus.contains(element.bindStatus)
                      : true) &&
                  (toolingType.length > 0
                      ? toolingType.contains(element.toolingType)
                      : true) &&
                  ((key.isNotEmpty
                          ? element.moldName?.contains(key) == true
                          : true) ||
                      (key.isNotEmpty
                          ? element.assetNo?.contains(key) == true
                          : true)))
              ?.toList() ??
          List.empty();
    } else {
      _mouldBindTaskListSearch.value = homeController.mouldBindList.value.data
              ?.where((element) => element.taskNo == taskNo)
              .first
              .mouldList
              ?.where((element) =>
                  (bindStatus.length > 0
                      ? bindStatus.contains(element.bindStatus)
                      : true) &&
                  (toolingType.length > 0
                      ? toolingType.contains(element.toolingType)
                      : true) &&
                  ((key.isNotEmpty
                          ? element.moldName?.contains(key) == true
                          : true) ||
                      (key.isNotEmpty
                          ? element.assetNo?.contains(key) == true
                          : true)))
              .toList() ??
          List.empty();
      Log.d("message---" + _mouldBindTaskListSearch.toString());
    }
  }

  @override
  void refresh() {
    super.refresh();
    _mouldBindTaskListSearch.value = homeController.mouldBindList.value.data
            ?.where((element) => element.taskNo == this.taskNo)
            .first
            .mouldList
            ?.toList() ??
        List.empty();
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

  doUploadData(String taskType) async {
    List<MouldList?>? mouldLists = mouldBindTaskListSearch
        ?.where((element) => element?.bindStatus == BIND_STATUS_WAITING_UPLOAD)
        ?.toList();

    if (mouldLists != null && mouldLists.length > 0) {
      Loading.show('上传中...');
      mouldLists.forEach((element) {
        uploadTask(element, taskType);
      });
    } else {
      toastInfo(msg: '当前无待上传状态的模具可上传');
    }
  }

  /**
   * {
      "address": "上海市浦东新区曹路镇金穗路775号",
      "bindLabels": [
      "XP000000001",
      "XP000000002"
      ],
      "cavityPhoto": {
      "docComments": "小刘现场拍摄",
      "documentName": "照片a",
      "downloadType": "url",
      "fileSize": 12344554,
      "fileSuffix": "jpg",
      "fullPath": "/path/to/file"
      },
      "labelType": 1,
      "lat": 123.45678,
      "lng": 123.45678,
      "nameplatePhoto": {
      "docComments": "小刘现场拍摄",
      "documentName": "照片a",
      "downloadType": "url",
      "fileSize": 12344554,
      "fileSuffix": "jpg",
      "fullPath": "/path/to/file"
      },
      "overallPhoto": {
      "docComments": "小刘现场拍摄",
      "documentName": "照片a",
      "downloadType": "url",
      "fileSize": 12344554,
      "fileSuffix": "jpg",
      "fullPath": "/path/to/file"
      }
      }
   */
  ///单个任务上传
  uploadTask(MouldList? element, String taskType) async {
    var jsonMaps = HashMap();
    jsonMaps['address'] = element?.address;
    jsonMaps['bindLabels'] = element?.bindLabels;
    jsonMaps['labelType'] = element?.labelType;
    jsonMaps['lat'] = element?.lat;
    jsonMaps['lng'] = element?.lng;

    if (taskType == MOULD_TASK_TYPE_PAY.toString()) {
      if (element?.nameplatePhoto?.fullPath != null &&
          element?.nameplatePhoto?.fullPath?.contains(APP_PACKAGE) == true) {
        element?.nameplatePhoto?.fileSuffix = 'jpg';
        element?.nameplatePhoto?.downloadType = 'url';
        element?.nameplatePhoto?.documentName =
            element.nameplatePhoto?.fullPath;
        var nameplatePhotoUUID =
            await FileApi.uploadFile(element?.nameplatePhoto?.fullPath ?? "");

        element?.nameplatePhoto?.fullPath = nameplatePhotoUUID;
      }
      if (element?.cavityPhoto?.fullPath != null &&
          element?.cavityPhoto?.fullPath?.contains(APP_PACKAGE) == true) {
        element?.cavityPhoto?.documentName = element.cavityPhoto?.fullPath;
        element?.cavityPhoto?.fileSuffix = 'jpg';
        element?.cavityPhoto?.downloadType = 'url';
        var cavityPhotoNetUUID =
            await FileApi.uploadFile(element?.cavityPhoto?.fullPath ?? "");
        element?.cavityPhoto?.fullPath = cavityPhotoNetUUID;
      }

      if (element?.overallPhoto?.fullPath != null &&
          element?.overallPhoto?.fullPath?.contains(APP_PACKAGE) == true) {
        element?.overallPhoto?.fileSuffix = 'jpg';
        element?.overallPhoto?.downloadType = 'url';
        element?.overallPhoto?.documentName = element.overallPhoto?.fullPath;
        var overallPhotoUUID =
            await FileApi.uploadFile(element?.overallPhoto?.fullPath ?? "");
        element?.overallPhoto?.fullPath = overallPhotoUUID;
      }

      jsonMaps['nameplatePhoto'] = element?.nameplatePhoto;
      jsonMaps['cavityPhoto'] = element?.cavityPhoto;
      jsonMaps['overallPhoto'] = element?.overallPhoto;

      /// state  1 正常  0 提示错误  -1 根据id删除本地数据
      int resultCode = await MouldTaskApi.uploadForPayType(
          element?.assetBindTaskId ?? 0, jsonEncode(jsonMaps));
      if (resultCode == API_RESPONSE_OK) {
        ///上传更新为已上传 状态
        element?.bindStatus = BIND_STATUS_UPLOADED;
        element?.bindStatusText = MOULD_BIND_STATUS[BIND_STATUS_UPLOADED];
        updateLabelStatus(taskType, element);

        ///删除已上传的图片
        if (element?.overallPhoto?.documentName?.isNotEmpty == true) {
          await File(element?.overallPhoto?.documentName ?? "").delete();
        }

        if (element?.nameplatePhoto?.documentName?.isNotEmpty == true) {
          await File(element?.nameplatePhoto?.documentName ?? "").delete();
        }

        if (element?.cavityPhoto?.documentName?.isNotEmpty == true) {
          await File(element?.cavityPhoto?.documentName ?? "").delete();
        }
      } else if (resultCode == -1) {
        homeController.mouldBindList.value.data
            ?.where((element) => element.taskNo == element.taskNo)
            .first
            .mouldList
            ?.removeWhere(
                (it) => it.assetBindTaskId == element?.assetBindTaskId);
        CacheUtils.to.saveMouldTask(homeController.mouldBindList.value, true);
      }
    } else {
      if (element?.nameplatePhoto?.fullPath?.contains(APP_PACKAGE) == true) {
        element?.nameplatePhoto?.fileSuffix = 'jpg';
        element?.nameplatePhoto?.documentName =
            element.nameplatePhoto?.fullPath;
        element?.nameplatePhoto?.downloadType = 'url';
        var nameplatePhotoUUID =
            await FileApi.uploadFile(element?.nameplatePhoto?.fullPath ?? "");
        element?.nameplatePhoto?.fullPath = nameplatePhotoUUID;
      }
      jsonMaps['nameplatePhoto'] = element?.nameplatePhoto;

      /// state  1 正常  0 提示错误  -1 根据id删除本地数据
      int resultCode = await MouldTaskApi.uploadForLableReplaceType(
          element?.labelReplaceTaskId ?? 0, jsonEncode(jsonMaps));

      if (resultCode == API_RESPONSE_OK) {
        ///上传更新为已上传 状态
        element?.bindStatus = BIND_STATUS_UPLOADED;
        element?.bindStatusText = MOULD_BIND_STATUS[BIND_STATUS_UPLOADED];
        updateLabelStatus(taskType, element);
        if (element?.nameplatePhoto?.documentName?.isNotEmpty == true) {
          await File(element?.nameplatePhoto?.documentName ?? "").delete();
        }
      } else if (resultCode == -1) {
        homeController.mouldBindList.value.data
            ?.where((element) => element.taskNo == element.taskNo)
            .first
            .mouldList
            ?.removeWhere(
                (it) => it.labelReplaceTaskId == element?.labelReplaceTaskId);
        CacheUtils.to.saveMouldTask(homeController.mouldBindList.value, true);
      }
    }
  }

  updateLabelStatus(String taskType, MouldList? mouldListItem) async {
    ///todo 暂时先去掉  待缓存逻辑确定后再放开
    ///全是已完成任务
    Log.d("绑定任务都已上传 ，现在${homeController.mouldBindList.value.data?.length}个任务");

    ///如果该模具里的绑定任务都是已经完成的上传 则本地删除任务
    var mouldList = homeController.mouldBindList.value.data
        ?.where((element) => element.taskNo == mouldListItem?.taskNo)
        .first
        .mouldList;
    if (mouldList
            ?.where((element) => element.bindStatus == BIND_STATUS_UPLOADED)
            .length ==
        mouldList?.length) {
      homeController.mouldBindList.value.data
          ?.removeWhere((element) => element.taskNo == mouldListItem?.taskNo);
      Log.e(
          "该任务下都已经上传 ，删除该模具任务现在还有${homeController.mouldBindList.value.data?.length}个任务");
      await CacheUtils.to
          .saveMouldTask(homeController.mouldBindList.value, true);

      ///返回到上一页
      Get.back();
    } else {
      var mouldItem = homeController.mouldBindList.value.data
          ?.where((element) => element.taskNo == mouldListItem?.taskNo)
          .first
          .mouldList
          ?.where((element) => element.assetNo == mouldListItem?.assetNo)
          .first;
      mouldItem = mouldListItem;
      CacheUtils.to.saveMouldTask(homeController.mouldBindList.value, true);

      ///重新取值 可实现刷新
      _mouldBindTaskListSearch.value = homeController.mouldBindList.value.data
              ?.where((element) => element.taskNo == mouldListItem?.taskNo)
              .first
              .mouldList ??
          List.empty();
    }
  }
}
