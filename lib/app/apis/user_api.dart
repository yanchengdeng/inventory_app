import 'dart:collection';

import 'package:dio/dio.dart';

import '../entity/user.dart';
import '../utils/http.dart';

/// 用户
class UserAPI<T> {
  static Future<UserLoginResponseEntity> profile() async {
    Map<String, dynamic> userProfile = HashMap();
    userProfile['x-resource-code'] = 'login_user';
     userProfile['x-user-code'] = 'login_user';
    Options options = Options();
    options.headers = userProfile;
    var response = await HttpUtil()
        .post('/login/user', queryParameters: userProfile, options: options);
    return UserLoginResponseEntity.fromJson(response);
  }
}
