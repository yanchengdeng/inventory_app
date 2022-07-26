import 'package:get/get.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';

import '../../../utils/cache.dart';

class MouldBindMouldlistController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    CacheUtils.to
        .getMouldTaskListByKeyOrStatus(Get.arguments['taskNo'], '', [-1], []);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
