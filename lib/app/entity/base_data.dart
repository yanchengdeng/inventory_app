/// 基础数据返回模板
class BaseResponseEntity {
  int? state;
  String? message;
  String? time;

  BaseResponseEntity({this.state, this.message, this.time});

  BaseResponseEntity.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    message = json['message'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['message'] = this.message;
    data['time'] = this.time;
    return data;
  }
}
