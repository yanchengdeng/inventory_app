import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Container(
        child: Column(children: [
          btnFlatButtonWidget(
              onPressed: () => {toastInfo(msg: "btnFloatButton")}),
          btnFlatButtonBorderOnlyWidget(
              onPressed: () => {}, iconFileName: 'account_header.png'),
          netImageCached(
              'https://pics2.baidu.com/feed/96dda144ad345982410408a93a5a5ca7caef84bc.jpeg?token=7fe1b75d4e2b6310cc2a52662dfedc7e'),
          inputTextEdit(isPassword: false),
          inputTextEdit(isPassword: true)
        ]),
      ),
    );
  }
}
