import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/inventory_tasklist/bindings/inventory_tasklist_binding.dart';
import '../modules/inventory_tasklist/views/inventory_tasklist_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/mine/bindings/mine_binding.dart';
import '../modules/mine/views/mine_view.dart';
import '../modules/mould_bind_tasklist/bindings/mould_bind_tasklist_binding.dart';
import '../modules/mould_bind_tasklist/views/mould_bind_tasklist_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'observers.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static const INITIAL = Routes.SPLASH;

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
      page: () => MouldBindTasklistView(),
      binding: MouldBindTasklistBinding(),
    ),
    GetPage(
      name: _Paths.INVENTORY_TASKLIST,
      page: () => InventoryTasklistView(),
      binding: InventoryTasklistBinding(),
    ),
  ];
}
