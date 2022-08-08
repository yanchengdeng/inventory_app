import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/utils/loading.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';

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
    MouldList? mouldList = _mouldBindTaskListSearch.value
        ?.where((element) => element?.bindStatus == BIND_STATUS_WAITING_UPLOAD)
        ?.first;

    Loading.show('上传中...');
    if (mouldList != null && mouldList.bindLabels != null) {
      if (taskType == MOULD_TASK_TYPE_PAY.toString()) {
        await MouldTaskApi.uploadForPayType(mouldList?.assetBindTaskId ?? 0,
            json.encode(mouldList?.bindLabels?[0]));
      } else {
        await MouldTaskApi.uploadForLableReplaceType(
            mouldList?.labelReplaceTaskId ?? 0,
            json.encode(mouldList?.bindLabels?[0]));
      }
      Loading.dismiss();
    } else {
      toastInfo(msg: '暂无需要上传');
    }
  }
}
