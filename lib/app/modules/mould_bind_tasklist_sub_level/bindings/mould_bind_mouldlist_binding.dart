import 'package:get/get.dart';

import '../controllers/mould_bind_mouldlist_controller.dart';

class MouldBindMouldlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MouldBindMouldlistController>(
      () => MouldBindMouldlistController(),
    );
  }
}
