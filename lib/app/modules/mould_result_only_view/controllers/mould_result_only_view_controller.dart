import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import '../../../entity/mould_bind.dart';
import '../../../services/storage.dart';
import '../../../values/server.dart';
import '../../../values/storage.dart';

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
