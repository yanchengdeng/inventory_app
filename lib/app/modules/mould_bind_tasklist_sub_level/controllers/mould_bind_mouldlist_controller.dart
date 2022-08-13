import 'dart:convert';
import 'package:get/get.dart';
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
      mouldLists.forEach((element) async {
        await uploadTask(element, taskType);
      });
    } else {
      toastInfo(msg: '暂无需要上传的任务');
    }
  }

  ///单个任务上传
  uploadTask(MouldList? element, String taskType) async {
    Loading.show('上传中...');

    Loading.dismiss();
  }

  updateLableStatus(String taskType, MouldList? element) {
    CacheUtils.to.updateMouldListState(taskType, element);
  }
}
