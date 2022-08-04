import 'dart:convert';

import 'package:get/get.dart';

import '../apis/apis.dart';
import '../entity/user.dart';
import '../services/services.dart';
import '../values/values.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  // 令牌 token
  String token = '';
  // 用户 profile
  UserLoginResponseEntity? userLoginResponseEntity = null;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      userLoginResponseEntity =
          (UserLoginResponseEntity.fromJson(jsonDecode(profileOffline)));
    }
  }

  // 保存 token
  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  // 获取 profile
  Future<UserLoginResponseEntity?> getProfile() async {
    userLoginResponseEntity = await UserAPI.profile();
    if (userLoginResponseEntity != null) {
      saveProfile(userLoginResponseEntity!);
    }
    return userLoginResponseEntity;
  }

  // 保存 profile
  Future<void> saveProfile(UserLoginResponseEntity profile) async {
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile));
  }

  // 注销
  Future<void> onLogout() async {
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    token = '';
  }
}
