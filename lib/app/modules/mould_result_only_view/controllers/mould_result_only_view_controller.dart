import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/utils/logger.dart';
import '../../../entity/MouldBindTask.dart';
import '../../../services/storage.dart';
import '../../../values/server.dart';
import '../../../values/storage.dart';

class MouldResultOnlyViewController extends GetxController {
  var isShowAllInfo = false.obs;

  ///已完成模具任务
  var mouldBindTaskFinished = MouldList().obs;

  void setMouldBindData(MouldList assertBindTaskInfo) async {
    mouldBindTaskFinished.value = assertBindTaskInfo;
  }

  ///获取网络图片展示地址
  String getNetImageUrl(String uriUuid) {
    return SERVER_FILE_UPLOAD +
        "/file/frontend/" +
        Uri.encodeComponent(uriUuid) +
        '?token=' +
        StorageService.to.getString(STORAGE_FILE_TOKEN) +
        "&mediaType=image";
  }

  @override
  void onInit() async {
    super.onInit();
    EasyLoading.show(status: "加载中...");
    await FileApi.getFileToken();
    var info = Get.arguments;
    MouldList? assertBindTaskInfo = MouldList.fromJson(info);
    Log.d("message=${assertBindTaskInfo}");
    mouldBindTaskFinished.value = assertBindTaskInfo;
    EasyLoading.dismiss();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
