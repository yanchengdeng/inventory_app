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

  ///资产盘点信息
  var _inventoryList = Rx<InventoryList?>(null);

  set inventoryList(value) => _inventoryList.value = value;

  get inventoryList => _inventoryList.value;

  ///tab 两个tab  默认选中第一个
  var _selectedTab = RxBool(true);
  set selectedTab(value) => _selectedTab.value = value;
  get selectedTab => _selectedTab.value;

  /// 磨具绑定搜索关键字
  var _mouldSearchKey = RxString("");
  set mouldSearchKey(value) => _mouldSearchKey.value = value;
  get mouldSearchKey => _mouldSearchKey.value;

  ///模具绑定搜索列表
  var _mouldBindTaskListSearch = Rx<FinishedTaskList?>(null);

  set mouldBindTaskListSearch(value) => _mouldBindTaskListSearch.value = value;

  get mouldBindTaskListSearch => _mouldBindTaskListSearch.value;

  ///模具资产信息
  var _assertBindTaskInfo = Rx<MouldList?>(null);
  set assertBindTaskInfo(value) => _assertBindTaskInfo.value = value;
  get assertBindTaskInfo => _assertBindTaskInfo.value;

  /// 盘点搜索关键字
  var _inventroySearchKey = RxString("");
  set inventroySearchKey(value) => _inventroySearchKey.value = value;
  get inventroySearchKey => _inventroySearchKey.value;
}
