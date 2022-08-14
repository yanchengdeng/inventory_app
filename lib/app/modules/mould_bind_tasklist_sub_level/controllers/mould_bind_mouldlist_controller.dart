import 'dart:collection';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/entity/UploadLabelParams.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/utils/loading.dart';
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
              ?.toList() ??
          List.empty();
    } else {
      _mouldBindTaskListSearch.value = homeController.mouldBindList.value.data
              ?.where((element) => element.taskNo == taskNo)
              ?.first
              ?.mouldList
              ?.toList() ??
          List.empty();
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
      toastInfo(msg: '暂无需要上传的任务');
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
      if (element?.nameplatePhoto?.fullPath?.contains(APP_PACKAGE) == true) {
        element?.nameplatePhoto?.fileSuffix = 'jpg';
        var nameplatePhotoUUID =
            await FileApi.uploadFile(element?.nameplatePhoto?.fullPath ?? "");
        element?.nameplatePhoto?.fullPath = nameplatePhotoUUID;
      }
      if (element?.cavityPhoto?.fullPath?.contains(APP_PACKAGE) == true) {
        element?.cavityPhoto?.fileSuffix = 'jpg';
        var cavityPhotoNetUUID =
            await FileApi.uploadFile(element?.cavityPhoto?.fullPath ?? "");
        element?.cavityPhoto?.fullPath = cavityPhotoNetUUID;
      }

      if (element?.overallPhoto?.fullPath?.contains(APP_PACKAGE) == true) {
        element?.overallPhoto?.fileSuffix = 'jpg';
        var overallPhotoUUID =
            await FileApi.uploadFile(element?.overallPhoto?.fullPath ?? "");
        element?.overallPhoto?.fullPath = overallPhotoUUID;
      }

      jsonMaps['nameplatePhoto'] = element?.nameplatePhoto;
      jsonMaps['cavityPhoto'] = element?.cavityPhoto;
      jsonMaps['overallPhoto'] = element?.overallPhoto;

      await MouldTaskApi.uploadForPayType(
          element?.assetBindTaskId ?? 0, jsonEncode(jsonMaps));

      ///上传更新为已上传 状态
      element?.bindStatus = BIND_STATUS_UPLOADED;
      element?.bindStatusText = MOULD_BIND_STATUS[BIND_STATUS_UPLOADED];
      updateLabelStatus(taskType, element);
    } else {
      if (element?.nameplatePhoto?.fullPath?.contains(APP_PACKAGE) == true) {
        element?.nameplatePhoto?.fileSuffix = 'jpg';
        var nameplatePhotoUUID =
            await FileApi.uploadFile(element?.nameplatePhoto?.fullPath ?? "");
        element?.nameplatePhoto?.fullPath = nameplatePhotoUUID;
      }
      jsonMaps['nameplatePhoto'] = element?.nameplatePhoto;
      await MouldTaskApi.uploadForLableReplaceType(
          element?.labelReplaceTaskId ?? 0, jsonEncode(jsonMaps));

      ///上传更新为已上传 状态
      element?.bindStatus = BIND_STATUS_UPLOADED;
      element?.bindStatusText = MOULD_BIND_STATUS[BIND_STATUS_UPLOADED];
      updateLabelStatus(taskType, element);
    }
  }

  updateLabelStatus(String taskType, MouldList? element) {
    CacheUtils.to.updateMouldListState(taskType, element);
  }
}
