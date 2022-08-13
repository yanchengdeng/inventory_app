import 'package:get/get.dart';

import '../controllers/test_r_f_i_d_controller.dart';

class TestRFIDBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestRFIDController>(
      () => TestRFIDController(),
    );
  }
}
