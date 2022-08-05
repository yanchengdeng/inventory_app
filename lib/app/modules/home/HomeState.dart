import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import '../../entity/inventory_list.dart';
import '../../entity/mould_bind.dart';
import '../../entity/user.dart';

/**
 * home 页数据
  */

class HomeState {
  ///tab 两个tab  默认选中第一个
  var _selectedTab = RxBool(true);
  set selectedTab(value) => _selectedTab.value = value;
  get selectedTab => _selectedTab.value;

  var _userProfile = Rx<UserLoginResponseEntity?>(null);
  set userProfile(value) => _userProfile.value = value;
  get userProfile => _userProfile.value;

  ///已完成资产盘点页面
  var inventoryFinishedPage = 1;
}
