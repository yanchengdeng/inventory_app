import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/apis/mould_task_api.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/server.dart';

import '../../../entity/mould_bind.dart';

/**
 * 模具绑定控制器  主要处理业务逻辑
 */
class MouldBindTasklistController extends GetxController {
  MouldBindList mouldBindList = new MouldBindList();

  //获取模具绑定列表
  getMouldTaskList() async {
    EasyLoading.show(status: "获取中...");
    mouldBindList =
        await MouldTaskApi.getMouldTaskList(CommonUtils.getCommonParams());
    if (mouldBindList.state == SERVER_RESULT_OK) {
      Log.d(
          "成功:${mouldBindList.data?.finishedTaskList?[0].mouldList?[0].moldName}");
    } else {
      Log.e("失败，重试");
    }
  }

  @override
  void onInit() {
    super.onInit();
    Log.d("MouldBindTasklistController--onInit()");
  }

  @override
  void onReady() {
    super.onReady();
    Log.d("MouldBindTasklistController--onReady()");
  }

  @override
  void onClose() {
    Log.d("MouldBindTasklistController--onClose()");
  }
}
