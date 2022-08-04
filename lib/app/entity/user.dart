//登录参数
class UserLoginParamsEntity {
  String? account;
  String? password;

  UserLoginParamsEntity({this.account, this.password});

  UserLoginParamsEntity.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['password'] = this.password;
    return data;
  }
}

//登录返回结果
class UserLoginResponseEntity {
  UserLoginResponseEntity({
    required this.data,
    required this.message,
    required this.state,
  });
  late final Data data;
  late final String message;
  late final int state;

  UserLoginResponseEntity.fromJson(Map<String, dynamic> json) {
    data = Data.fromJson(json['data']);
    message = json['message'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    _data['message'] = message;
    _data['state'] = state;
    return _data;
  }
}

class Data {
  Data({
    required this.duns,
    required this.name,
    required this.sgmUser,
    required this.userCode,
  });
  late final String duns;
  late final String name;
  late final bool sgmUser;
  late final String userCode;

  Data.fromJson(Map<String, dynamic> json) {
    duns = json['duns'];
    name = json['name'];
    sgmUser = json['sgmUser'];
    userCode = json['userCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['duns'] = duns;
    _data['name'] = name;
    _data['sgmUser'] = sgmUser;
    _data['userCode'] = userCode;
    return _data;
  }
}
