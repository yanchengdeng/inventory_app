import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/values/fontsize.dart';
import '../../../style/style.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/mine_controller.dart';

/**
 * 用户信息页面
 */
class MineView extends GetView<MineController> {

  var homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: Container(
        alignment: AlignmentDirectional.topStart,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white60),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                            homeController.state.userData.value.name ??"" ,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: AppFontSize.FONT_SIZE_SUB_TITLE
                                    .toDouble())),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Obx(
                          () => Text(
                            homeController.state.userData.value.userCode ??"",
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize:
                                    AppFontSize.FONT_SIZE_SUB_TITLE.toDouble()),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Text(''),
              flex: 1,
            ),
            Container(
              width: 150,
              height: 45,
              child: ElevatedButton(
                  child: Text(
                    '退出账号',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble()),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColor.accentColor)),
                  onPressed: () => {
                        CommonUtils.showCommonDialog(
                            content: '确定要退出登录吗?',
                            callback: () => {CommonUtils.logOut()})
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
