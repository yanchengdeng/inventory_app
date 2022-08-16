import 'package:get/get.dart';

import '../controllers/inventory_task_handler_controller.dart';

class InventoryTaskHandlerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryTaskHandlerController>(
      () => InventoryTaskHandlerController(),
    );
  }
}
