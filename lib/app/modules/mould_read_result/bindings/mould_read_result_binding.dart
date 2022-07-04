import 'package:get/get.dart';

import '../controllers/mould_read_result_controller.dart';

class MouldReadResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MouldReadResultController>(
      () => MouldReadResultController(),
    );
  }
}
