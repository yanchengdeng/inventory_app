import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/style/color.dart';
import '../../../widgets/toast.dart';
import '../../home/views/home_view.dart';
import '../../mine/views/mine_view.dart';
import '../controllers/main_controller.dart';

/**
 * 主页 ：  首页 +  我的
 */
class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(builder: (controller) {
      var isExit = false;
      return WillPopScope(
        onWillPop: () async {
          if (!isExit) {
            isExit = true;
            toastInfo(msg: '再次点击退出应用程序');
            //2秒内没有点击 isExit 从新置为false
            Future.delayed(const Duration(milliseconds: 2000), () {
              isExit = false;
            });
            return false;
          } else {
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                HomeView(),
                MineView(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColor.accentColor,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.manage_accounts), label: '我的'),
            ],
          ),
        ),
      );
    });
  }
}
