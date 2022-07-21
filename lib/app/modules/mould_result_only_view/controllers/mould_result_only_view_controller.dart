import 'package:get/get.dart';
import 'package:inventory_app/app/utils/logger.dart';

import '../../home/controllers/home_controller.dart';

class MouldResultOnlyViewController extends GetxController {
  final homeController = Get.find<HomeController>();

  var isShowAllInfo = false.obs;

  @override
  void onInit() {
    super.onInit();
    String taskNo = Get.arguments['taskNo'];
    String assertNo = Get.arguments['assetNo'];
    Log.d("taskNo=${taskNo},assetNo=${assertNo}");

    homeController.getAssetBindTaskInfo(
        Get.arguments['taskNo'], Get.arguments['assetNo']);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
