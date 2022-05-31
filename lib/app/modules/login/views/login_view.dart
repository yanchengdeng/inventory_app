import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/login_controller.dart';

///
///登录页
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
                    // onChanged: (value) {
                    //   loginParams.password = value;
                    // },
                    controller: controller.passController,
                  ),
                  TextButton(
                    child: const Text('登录'),
                    onPressed: () async {
                      controller.handleSignIn();
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
