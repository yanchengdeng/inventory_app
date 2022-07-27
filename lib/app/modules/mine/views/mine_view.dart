import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/values/fontsize.dart';
import '../../../routes/app_pages.dart';
import '../../../style/style.dart';
import '../controllers/mine_controller.dart';

/**
 * 用户信息页面
 */
class MineView extends GetView<MineController> {
  final mineController = Get.put(MineController());

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
                // Container(
                //     width: 80,
                //     height: 80,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(100),
                //         image: DecorationImage(
                //           fit: BoxFit.fill,
                //           image: NetworkImage(
                //               'https://ts1.cn.mm.bing.net/th/id/R-C.cd2db2f6c8e5cc456ef0e62f2c871360?rik=dVxM55sEqkPztA&riu=http%3a%2f%2fsc.68design.net%2fphotofiles%2f201409%2fcxoVx6if1c.jpg&ehk=ya3IyE4KeapPkWVgYRGQVkifGvXz4cscxqjrpqTxAfw%3d&risl=&pid=ImgRaw&r=0'),
                //         ))),
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('上海通用集团分公司',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  AppFontSize.FONT_SIZE_SUB_TITLE.toDouble())),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'anly',
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize:
                                  AppFontSize.FONT_SIZE_SUB_TITLE.toDouble()),
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
