import 'dart:convert';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/UserInfo.dart';
import '../apis/apis.dart';
import '../services/services.dart';
import '../values/values.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  // 令牌 token
  String token = '';
  // 用户 profile
  UserData? userData = null;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      userData = UserData.fromJson(jsonDecode(profileOffline));
    }
  }

  // 保存 token
  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  // 获取 profile
  Future<UserData?> getProfile() async {
    var userInfo = await UserAPI.profile();
    return userInfo;
  }

  // 保存 profile
  Future<void> saveProfile(UserData? userData) async {
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(userData));
  }

  // 注销
  Future<void> onLogout() async {
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    await StorageService.to.setString(STORAGE_USER_PROFILE_KEY, '');
    userData = null;
    token = '';
  }
}
