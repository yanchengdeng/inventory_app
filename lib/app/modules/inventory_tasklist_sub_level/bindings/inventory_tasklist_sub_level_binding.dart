import 'package:get/get.dart';

import '../controllers/inventory_tasklist_sub_level_controller.dart';

class InventoryTasklistSubLevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryTasklistSubLevelController>(
      () => InventoryTasklistSubLevelController(),
    );
  }
}
