import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:inventory_app/app/entity/UserInfo.dart';
import 'package:inventory_app/app/store/store.dart';
import 'package:inventory_app/app/values/constants.dart';
import '../utils/http.dart';

/// 用户
class UserAPI<T> {
  static Future<UserData?> profile() async {
    Map<String, dynamic> userProfile = HashMap();
    userProfile['x-resource-code'] = 'login_user';
    userProfile['x-user-code'] = 'login_user';
    Options options = Options();
    options.headers = userProfile;
    var response = await HttpUtil()
        .post('/login/user', queryParameters: userProfile, options: options);

    try {
      if (response['state'] == API_RESPONSE_OK) {
        var userInfo = UserInfo.fromJson(response);
        UserStore.to.saveProfile(userInfo.data);
        return userInfo.data;
      } else {
        return UserStore.to.userData;
      }
    } catch (e) {
      return UserStore.to.userData;
    }
  }
}
