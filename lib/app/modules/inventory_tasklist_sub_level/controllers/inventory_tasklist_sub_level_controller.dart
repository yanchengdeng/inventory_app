import 'package:get/get.dart';

import '../../../entity/InventoryData.dart';
import '../../../utils/cache.dart';
import '../../home/controllers/home_controller.dart';

class InventoryTasklistSubLevelController extends GetxController {
  ///资产盘点搜索列表
  var _inventoryTaskListSearch = RxList<InventoryDetail?>(List.empty());

  set inventoryTaskListSearch(value) => _inventoryTaskListSearch.value = value;

  get inventoryTaskListSearch => _inventoryTaskListSearch.value;

  final homeController = Get.find<HomeController>();

  ///查找查询数据
  findByParams(isFinish, String taskNo, String key, List<int> bindStatus,
      List<String> toolingType) async {
    if (isFinish) {
      var task = homeController.inventoryFinishedList
          ?.where((element) => element.taskNo == taskNo)
          ?.first;
      var mouldList = task?.list;
      _inventoryTaskListSearch.value = mouldList;
    } else {
      _inventoryTaskListSearch.value = await CacheUtils.to
          .getInventoryTaskListByKeyOrStatus(
              taskNo, key, bindStatus, toolingType);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
