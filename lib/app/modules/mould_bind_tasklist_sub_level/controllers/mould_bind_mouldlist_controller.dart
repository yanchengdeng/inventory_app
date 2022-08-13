import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/entity/cache_data.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/utils/loading.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';

import '../../../entity/base_data.dart';
import '../../../entity/base_data.dart';
import '../../../entity/mould_bind.dart';
import '../../../utils/cache.dart';
import '../../../widgets/toast.dart';

class MouldBindMouldlistController extends GetxController {
  ///模具绑定搜索列表
  var _mouldBindTaskListSearch = RxList<MouldList?>(List.empty());

  set mouldBindTaskListSearch(value) => _mouldBindTaskListSearch.value = value;

  get mouldBindTaskListSearch => _mouldBindTaskListSearch.value;

  final homeController = Get.find<HomeController>();

  ///查找查询数据
  findByParams(isFinish, String taskNo, String key, List<int> bindStatus,
      List<String> toolingType) async {
    if (isFinish) {
      var task = homeController.mouldTaskFinishedList
          ?.where((element) => element.taskNo == taskNo)
          ?.first;
      var mouldList = task?.mouldList;
      _mouldBindTaskListSearch.value = mouldList;
    } else {
      _mouldBindTaskListSearch.value = await CacheUtils.to
          .getMouldTaskListByKeyOrStatus(taskNo, key, bindStatus, toolingType);
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

  doUploadData(String taskType) async {
    List<MouldList?>? mouldLists = _mouldBindTaskListSearch.value
        ?.where((element) => element?.bindStatus == BIND_STATUS_WAITING_UPLOAD)
        ?.toList();

    if (mouldLists != null && mouldLists.length > 0) {
      mouldLists.forEach((element) async {
        await uploadTask(element, taskType);
      });
    } else {
      toastInfo(msg: '暂无需要上传任务');
    }
  }

  ///单个任务上传
  uploadTask(MouldList? element, String taskType) async {
    Loading.show('上传中...');
    UploadBindLabels uploadBindLabels = UploadBindLabels();
    if (element?.nameplatePhoto?.fullPath != null) {
      ///有照片则上传照片
      String? nameImageUrl = element?.nameplatePhoto?.fullPath;
      if (nameImageUrl != null && nameImageUrl.contains(APP_PACKAGE)) {
        String uuid = await FileApi.uploadFile(
            element?.nameplatePhoto?.fullPath ?? "");
        element?.nameplatePhoto?.fullPath == uuid;
        uploadBindLabels.nameplatePhoto = NameplatePhotoUpload();
        uploadBindLabels.nameplatePhoto?.fullPath = uuid;
      }
    }

    if (element?.cavityPhoto?.fullPath != null) {
      ///有照片则上传照片
      String? nameImageUrl = element?.cavityPhoto?.fullPath;
      if (nameImageUrl != null && nameImageUrl.contains(APP_PACKAGE)) {
        String uuid = await FileApi.uploadFile(
            element?.cavityPhoto?.fullPath ?? "");
        element?.cavityPhoto?.fullPath == uuid;

        uploadBindLabels.cavityPhoto = NameplatePhotoUpload();
        uploadBindLabels.cavityPhoto?.fullPath = uuid;
      }
    }

    if (element?.overallPhoto?.fullPath != null) {
      ///有照片则上传照片
      String? nameImageUrl = element?.overallPhoto?.fullPath;
      if (nameImageUrl != null && nameImageUrl.contains(APP_PACKAGE)) {
        String uuid = await FileApi.uploadFile(
            element?.overallPhoto?.fullPath ?? "");
        element?.overallPhoto?.fullPath == uuid;
        uploadBindLabels.overallPhoto = NameplatePhotoUpload();
        uploadBindLabels.overallPhoto?.fullPath = uuid;
      }
    }

    // uploadBindLabels.bindLabels = element?.bindLabels.toString();
    // if (taskType == MOULD_TASK_TYPE_PAY.toString()) {
    //   await MouldTaskApi.uploadForPayType(
    //       element?.assetBindTaskId ?? 0, json.encode(uploadBindLabels));
    //
    //   element?.bindStatus = BIND_STATUS_UPLOADED;
    //   await updateLableStatus(taskType, element);
    // } else {
    //   await MouldTaskApi.uploadForLableReplaceType(
    //       element?.labelReplaceTaskId ?? 0, json.encode(uploadBindLabels));
    //
    //   element?.bindStatus = BIND_STATUS_UPLOADED;
    //
    //   await updateLableStatus(taskType, element);
    // }
    Loading.dismiss();
  }

  updateLableStatus(String taskType, MouldList? element) {
    CacheUtils.to.updateMouldListState(taskType, element);
  }
}
