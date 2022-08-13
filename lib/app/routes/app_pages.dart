import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/inventory_tasklist/bindings/inventory_tasklist_binding.dart';
import '../modules/inventory_tasklist/views/inventory_tasklist_view.dart';
import '../modules/inventory_tasklist_sub_level/bindings/inventory_tasklist_sub_level_binding.dart';
import '../modules/inventory_tasklist_sub_level/views/inventory_tasklist_sub_level_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/mine/bindings/mine_binding.dart';
import '../modules/mine/views/mine_view.dart';
import '../modules/mould_bind_tasklist/bindings/mould_bind_tasklist_binding.dart';
import '../modules/mould_bind_tasklist/views/mould_bind_tasklist_view.dart';
import '../modules/mould_bind_tasklist_sub_level/bindings/mould_bind_mouldlist_binding.dart';
import '../modules/mould_bind_tasklist_sub_level/views/mould_bind_mouldlist_view.dart';
import '../modules/mould_read_result/bindings/mould_read_result_binding.dart';
import '../modules/mould_read_result/views/mould_read_result_view.dart';
import '../modules/mould_result_only_view/bindings/mould_result_only_view_binding.dart';
import '../modules/mould_result_only_view/views/mould_result_only_view_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/take_photo/bindings/take_photo_binding.dart';
import '../modules/take_photo/views/take_photo_view.dart';
import '../modules/testRFID/bindings/test_r_f_i_d_binding.dart';
import '../modules/testRFID/views/test_r_f_i_d_view.dart';
import '../store/store.dart';
import 'observers.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  // static const INITIAL =   Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.MINE,
      page: () => MineView(),
      binding: MineBinding(),
    ),
    GetPage(
      name: _Paths.MOULD_BIND_TASKLIST,
      page: () => MouldBindTaskListView(),
      binding: MouldBindTasklistBinding(),
    ),
    GetPage(
      name: _Paths.INVENTORY_TASKLIST,
      page: () => InventoryTaskListView(),
      binding: InventoryTasklistBinding(),
    ),
    GetPage(
      name: _Paths.MOULD_BIND_MOULDLIST,
      page: () => MouldBindMouldListView(),
      binding: MouldBindMouldlistBinding(),
    ),
    GetPage(
      name: _Paths.MOULD_READ_RESULT,
      page: () => MouldReadResultView(),
      binding: MouldReadResultBinding(),
    ),
    GetPage(
      name: _Paths.MOULD_RESULT_ONLY_VIEW,
      page: () => MouldResultOnlyViewView(),
      binding: MouldResultOnlyViewBinding(),
    ),
    GetPage(
      name: _Paths.TAKE_PHOTO,
      page: () => TakePhotoView(),
      binding: TakePhotoBinding(),
    ),
    GetPage(
      name: _Paths.INVENTORY_TASKLIST_SUB_LEVEL,
      page: () => InventoryTasklistSubLevelView(),
      binding: InventoryTasklistSubLevelBinding(),
    ),
    GetPage(
      name: _Paths.TEST_R_F_I_D,
      page: () => TestRFIDView(),
      binding: TestRFIDBinding(),
    ),
  ];
}
