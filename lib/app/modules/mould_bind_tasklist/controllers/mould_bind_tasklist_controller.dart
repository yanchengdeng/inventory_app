import 'package:get/get.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/utils/logger.dart';
import '../../../entity/MouldBindTask.dart';
import '../../home/controllers/home_controller.dart';

/**
 * 模具绑定控制器  主要处理业务逻辑
 */
class MouldBindTaskListController extends GetxController {
  final homeController = Get.find<HomeController>();

  List<MouldTaskItem> mouldTaskItems = RxList<MouldTaskItem>();

  void getMouldTaskItems() {
    mouldTaskItems = homeController.mouldBindList.value.data ?? List.empty();
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
  void onClose() {
    homeController.state.selectedMouldTab = true;
  }

  @override
  void refresh() async {
    super.refresh();
    homeController.mouldBindList.value = await CacheUtils.to.getMouldTask();
    getMouldTaskItems();
  }
}
