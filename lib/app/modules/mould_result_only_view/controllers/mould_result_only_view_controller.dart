import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/utils/logger.dart';

import '../../../entity/mould_bind.dart';
import '../../home/controllers/home_controller.dart';

class MouldResultOnlyViewController extends GetxController {
  var isShowAllInfo = false.obs;

  ///已完成模具任务
  var _mouldBindTaskFinished = Rx<MouldList?>(null);

  set mouldBindTaskFinished(value) => _mouldBindTaskFinished.value = value;

  get mouldBindTaskFinished => _mouldBindTaskFinished.value;

  void setMouldBindData(MouldList? assertBindTaskInfo) async {
    await FileApi.getFileToken();
    _mouldBindTaskFinished.value = assertBindTaskInfo;
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
}
