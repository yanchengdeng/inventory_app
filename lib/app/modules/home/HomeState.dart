import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import '../../entity/inventory_list.dart';
import '../../entity/mould_bind.dart';

/**
 * home 页数据
  */

class HomeState {


  ///tab 两个tab  默认选中第一个
  var _selectedTab = RxBool(true);
  set selectedTab(value) => _selectedTab.value = value;
  get selectedTab => _selectedTab.value;


}
