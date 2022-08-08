import 'package:get/get.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/utils/logger.dart';

import '../../../entity/mould_bind.dart';
import '../../../utils/cache.dart';

class MouldBindMouldlistController extends GetxController {
  ///模具绑定搜索列表
  var _mouldBindTaskListSearch = RxList<MouldList?>(List.empty());

  set mouldBindTaskListSearch(value) => _mouldBindTaskListSearch.value = value;

  get mouldBindTaskListSearch => _mouldBindTaskListSearch.value;

  final homeController = Get.find<HomeController>();

  ///查找查询数据
  findByParams(isFinish, String taskNo, String key, List<int> bindStatus,
      List<String> toolingType) async {
    if (isFinish) {
      var task = homeController.mouldTaskFinishedList
          ?.where((element) => element.taskNo == taskNo)
          ?.first;
      var mouldList = task?.mouldList;
      _mouldBindTaskListSearch.value = mouldList;
    } else {
      _mouldBindTaskListSearch.value = await CacheUtils.to
          .getMouldTaskListByKeyOrStatus(taskNo, key, bindStatus, toolingType);
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
