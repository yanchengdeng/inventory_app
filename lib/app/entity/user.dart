//登录参数
class UserLoginParamsEntity {
  String? username;
  String? password;

  UserLoginParamsEntity({this.username, this.password});

  UserLoginParamsEntity.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}

//登录返回结果
class UserLoginResponseEntity {
  String? token;
  String? name;
  String? avator;

  UserLoginResponseEntity({this.token, this.name, this.avator});

  UserLoginResponseEntity.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    avator = json['avator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['name'] = this.name;
    data['avator'] = this.avator;
    return data;
  }
}
