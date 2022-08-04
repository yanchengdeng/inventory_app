import 'dart:developer';

import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/store/store.dart';

import '../../../utils/cache.dart';
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
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
      
  }
}
