import 'package:get/get.dart';
import 'package:inventory_app/app/entity/InventoryData.dart';
import 'package:inventory_app/app/utils/cache.dart';

import '../../../entity/MouldBindTask.dart';
import '../../../utils/logger.dart';
import '../../home/controllers/home_controller.dart';

class InventoryTasklistController extends GetxController {
  final homeController = Get.find<HomeController>();

  var inventroyList = <InventoryFinishedList>[].obs;

  void getInventoryList() {
    inventroyList.value =
        homeController.inventoryList.value.data ?? List.empty();
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

    ///恢复选择状态
    homeController.state.selectedInventoryTab = true;
  }

  @override
  void refresh() async {
    super.refresh();
    homeController.inventoryList.value = await CacheUtils.to.getInventoryTask();
    getInventoryList();
  }
}
