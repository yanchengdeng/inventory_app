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
  int? code;
  String? msg;
  String? time;
  // Data? data;

  UserLoginResponseEntity({this.code, this.msg, this.time});

  UserLoginResponseEntity.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    return data;
  }
}

class Data {
  int? id;
  String? username;
  String? nickname;
  String? mobile;
  String? avatar;
  String? alipay;
  String? wechat;
  String? openid;
  int? fromB;
  String? myHost;
  String? storeHash;
  int? storeId;
  String? storeName;
  String? address;
  String? storeQrcode;
  String? storeMobile;
  String? storeImg;
  String? loginTime;
  int? updateTime;
  String? token;

  Data(
      {this.id,
      this.username,
      this.nickname,
      this.mobile,
      this.avatar,
      this.alipay,
      this.wechat,
      this.openid,
      this.fromB,
      this.myHost,
      this.storeHash,
      this.storeId,
      this.storeName,
      this.address,
      this.storeQrcode,
      this.storeMobile,
      this.storeImg,
      this.loginTime,
      this.updateTime,
      this.token});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    nickname = json['nickname'];
    mobile = json['mobile'];
    avatar = json['avatar'];
    alipay = json['alipay'];
    wechat = json['wechat'];
    openid = json['openid'];
    fromB = json['from_b'];
    myHost = json['my_host'];
    storeHash = json['store_hash'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    address = json['address'];
    storeQrcode = json['store_qrcode'];
    storeMobile = json['store_mobile'];
    storeImg = json['store_img'];
    loginTime = json['login_time'];
    updateTime = json['update_time'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['nickname'] = this.nickname;
    data['mobile'] = this.mobile;
    data['avatar'] = this.avatar;
    data['alipay'] = this.alipay;
    data['wechat'] = this.wechat;
    data['openid'] = this.openid;
    data['from_b'] = this.fromB;
    data['my_host'] = this.myHost;
    data['store_hash'] = this.storeHash;
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    data['address'] = this.address;
    data['store_qrcode'] = this.storeQrcode;
    data['store_mobile'] = this.storeMobile;
    data['store_img'] = this.storeImg;
    data['login_time'] = this.loginTime;
    data['update_time'] = this.updateTime;
    data['token'] = this.token;
    return data;
  }
}
