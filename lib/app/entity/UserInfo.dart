/// data : {"duns":"654539584","name":"供应商spl01","sgmUser":false,"userCode":"spl01"}
/// message : ""
/// state : 1

class UserInfo {
  UserInfo({
    UserData? data,
      String? message, 
      int? state,}){
    _data = data;
    _message = message;
    _state = state;
}

  UserInfo.fromJson(dynamic json) {
    _data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    _message = json['message'];
    _state = json['state'];
  }
  UserData? _data;
  String? _message;
  int? _state;
UserInfo copyWith({  UserData? data,
  String? message,
  int? state,
}) => UserInfo(  data: data ?? _data,
  message: message ?? _message,
  state: state ?? _state,
);
  UserData? get data => _data;
  String? get message => _message;
  int? get state => _state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['message'] = _message;
    map['state'] = _state;
    return map;
  }

}

/// duns : "654539584"
/// name : "供应商spl01"
/// sgmUser : false
/// userCode : "spl01"

class UserData {
  UserData({
      String? duns, 
      String? name, 
      bool? sgmUser, 
      String? userCode,}){
    _duns = duns;
    _name = name;
    _sgmUser = sgmUser;
    _userCode = userCode;
}

  UserData.fromJson(dynamic json) {
    _duns = json['duns'];
    _name = json['name'];
    _sgmUser = json['sgmUser'];
    _userCode = json['userCode'];
  }
  String? _duns;
  String? _name;
  bool? _sgmUser;
  String? _userCode;
  UserData copyWith({  String? duns,
  String? name,
  bool? sgmUser,
  String? userCode,
}) => UserData(  duns: duns ?? _duns,
  name: name ?? _name,
  sgmUser: sgmUser ?? _sgmUser,
  userCode: userCode ?? _userCode,
);
  String? get duns => _duns;
  String? get name => _name;
  bool? get sgmUser => _sgmUser;
  String? get userCode => _userCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['duns'] = _duns;
    map['name'] = _name;
    map['sgmUser'] = _sgmUser;
    map['userCode'] = _userCode;
    return map;
  }

}