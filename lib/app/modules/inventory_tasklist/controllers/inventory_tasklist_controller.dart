import 'package:get/get.dart';
import 'package:inventory_app/app/entity/InventoryData.dart';

import '../../../utils/logger.dart';
import '../../home/controllers/home_controller.dart';

class InventoryTasklistController extends GetxController {
  final homeController = Get.find<HomeController>();

  List<InventoryFinishedList> inventroyList = RxList<InventoryFinishedList>();

  void getInventoryList() {
    inventroyList = homeController.inventoryList.value.data ?? List.empty();
  }

  @override
  void onInit() {
    super.onInit();
    Log.d("InventoryTasklistController--onReady()");
  }

  @override
  void onReady() {
    super.onReady();
    Log.d("InventoryTasklistController--onReady()");
  }

  @override
  void onClose() {
    Log.d("InventoryTasklistController--onClose()");
  }
}
