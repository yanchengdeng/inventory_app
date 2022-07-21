import 'package:get/get.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';

class MouldBindMouldlistController extends GetxController {
  final homeController = Get.find<HomeController>();
  @override
  void onInit() {
    super.onInit();

    homeController
        .getMouldTaskListByKeyOrStatus(Get.arguments['taskNo'], '', [-1], []);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
