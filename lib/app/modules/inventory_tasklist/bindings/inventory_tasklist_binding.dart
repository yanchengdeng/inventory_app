import 'package:get/get.dart';

import '../controllers/inventory_tasklist_controller.dart';

class InventoryTasklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryTasklistController>(
      () => InventoryTasklistController(),
    );
  }
}
