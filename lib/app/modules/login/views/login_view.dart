import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/common/zh_hans.dart';
import 'package:inventory_app/app/data/login_params.dart';

import '../controllers/login_controller.dart';
import 'package:inventory_app/app/data/login_params.dart';

///
///登录页
///
///
///


class LoginView extends GetView<LoginController> {
  final loginParams = login_params();
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
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: '请输入手机号',
                      labelText: '手机号',
                    ),
                    onChanged: (value) {
                      loginParams.phone = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: '密码',
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      loginParams.password = value;
                    },
                  ),
                  TextButton(
                    child: const Text('登录'),
                    onPressed: ()  {
                     
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
