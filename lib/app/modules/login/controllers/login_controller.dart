import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/user.dart';
import 'package:inventory_app/app/routes/app_pages.dart';

import '../../../apis/user_api.dart';
import '../../../store/store.dart';

class LoginController extends GetxController {
  // 手机号的控制器
  final TextEditingController phoneController = TextEditingController();
  // 密码的控制器
  final TextEditingController passController = TextEditingController();

  // 执行登录操作
  handleSignIn() async {
    // if (!duIsEmail(_emailController.value.text)) {
    //   toastInfo(msg: '请正确输入邮件');
    //   return;
    // }
    // if (!duCheckStringLength(_passController.value.text, 6)) {
    //   toastInfo(msg: '密码不能小于6位');
    //   return;
    // }

    UserLoginParamsEntity params = UserLoginParamsEntity(
        username: phoneController.value.text,
        // password: duSHA256(passController.value.text),
        password: passController.value.text);

    UserLoginResponseEntity userProfile = await UserAPI.login(
      params: params,
    );
    UserStore.to.saveProfile(userProfile);

    Get.offAndToNamed(Routes.HOME);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }
}
