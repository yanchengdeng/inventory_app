import 'package:get/get.dart';

import '../controllers/mould_bind_tasklist_controller.dart';

class MouldBindTasklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MouldBindTasklistController>(
      () => MouldBindTasklistController(),
    );
  }
}
