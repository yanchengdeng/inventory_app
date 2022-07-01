import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import '../../entity/inventory_list.dart';
import '../../entity/mould_bind.dart';

/**
 * home 页数据
  */

class HomeState {
  ///模具绑定信息
  var _mouldBindTaskList = Rx<MouldBindList?>(null);

  set mouldBindTaskList(value) => _mouldBindTaskList.value = value;

  get mouldBindTaskList => _mouldBindTaskList.value;

  ///根据模具任务状态 获取对应集合数据
  List<MouldList> mouldBindTaskListForWaitBind(int position, int status) {
    return _mouldBindTaskList
            .value?.data?.unfinishedTaskList?[position]?.mouldList
            ?.where((element) => element.bindStatus == status)
            ?.toList() ??
        List.empty();
  }

  ///资产盘点信息
  var _inventoryList = Rx<InventoryList?>(null);

  set inventoryList(value) => _inventoryList.value = value;

  get inventoryList => _inventoryList.value;

  ///tab 两个tab  默认选中第一个
  var _selectedTab = RxBool(true);
  set selectedTab(value) => _selectedTab.value = value;
  get selectedTab => _selectedTab.value;
}
