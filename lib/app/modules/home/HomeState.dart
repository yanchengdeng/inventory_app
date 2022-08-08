import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import '../../entity/inventory_list.dart';
import '../../entity/mould_bind.dart';
import '../../entity/user.dart';

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

  var _userProfile = Rx<UserLoginResponseEntity?>(null);
  set userProfile(value) => _userProfile.value = value;
  get userProfile => _userProfile.value;

  ///已完成资产盘点页面
  var inventoryFinishedPage = 1;


  ///已完成模具任务页面
  var mouldTaskFinishedPage = 1;
}
