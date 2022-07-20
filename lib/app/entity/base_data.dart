/// 文件服务器返回数据
/// {
///       "data": "mzcxi2XdLYD",
///        "state": 1
///    }
class FileTokenResponseEntity {
  int? state;
  String? message;
  String? data;

  FileTokenResponseEntity({this.state, this.message, this.data});

  FileTokenResponseEntity.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
