import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import '../../entity/UserInfo.dart';

/**
 * home 页数据
  */

class HomeState {
  ///tab 两个tab  模具任务 默认选中第一个
  var _selectedMouldTab = RxBool(true);
  set selectedMouldTab(value) => _selectedMouldTab.value = value;
  get selectedMouldTab => _selectedMouldTab.value;

  ///tab 两个tab  盘点任务默认选中第一个
  var _selectedInventoryTab = RxBool(true);
  set selectedInventoryTab(value) => _selectedInventoryTab.value = value;
  get selectedInventoryTab => _selectedInventoryTab.value;

  var userData = UserData(duns: "", name: "", sgmUser: false, userCode: "").obs;

  ///已完成资产盘点页面  默认0 开始
  var inventoryFinishedPage = 0;

  ///已完成模具任务页面
  var mouldTaskFinishedPage = 0;
}
