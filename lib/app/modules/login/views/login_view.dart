import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/widgets/button.dart';
import '../controllers/login_controller.dart';

///
///
///登录页: 账号密码登录    已废弃  改为 网页授权登录 详细见  splash_view
///
///
///

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录页"),
        centerTitle: true,
      ),
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: '请输入用户名',
                      labelText: '用户名',
                    ),
                    controller: controller.phoneController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: "请输入密码",
                      labelText: '密码',
                    ),
                    obscureText: true,
                    maxLines: 1,
                    controller: controller.passController,
                  ),
                  btnFlatButtonWidget(
                    title: '登录',
                    onPressed: () async {
                      controller.handleSignIn();
                    },
                  ),
                  btnFlatButtonWidget(
                    title: '文件',
                    onPressed: () async {
                      controller.handleSignIn1();
                    },
                  ),
                ].expand(
                  (widget) => [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
