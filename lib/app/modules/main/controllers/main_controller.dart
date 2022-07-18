import 'dart:developer';

import 'package:get/get.dart';
import 'package:inventory_app/app/store/store.dart';

import '../../../utils/logger.dart';

class MainController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    Log.d("MainController--onInit()--token=${UserStore.to.token}");
  }
}
