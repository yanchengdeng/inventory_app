import 'package:get/get.dart';

import '../controllers/mould_result_only_view_controller.dart';

class MouldResultOnlyViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MouldResultOnlyViewController>(
      () => MouldResultOnlyViewController(),
    );
  }
}
