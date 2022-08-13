/// data : ["04449700000000000000104E","044497000000000000001163","0444970000000000000004BB"]
/// type : 1

///低层rfid 与扫描 发出的 信号  1  rfid 读取 2 扫描读取
class ReadLabelInfo {
  ReadLabelInfo({
      List<String>? data, 
      int? type,}){
    _data = data;
    _type = type;
}

  ReadLabelInfo.fromJson(dynamic json) {
    _data = json['data'] != null ? json['data'].cast<String>() : [];
    _type = json['type'];
  }
  List<String>? _data;
  int? _type;
ReadLabelInfo copyWith({  List<String>? data,
  int? type,
}) => ReadLabelInfo(  data: data ?? _data,
  type: type ?? _type,
);
  List<String>? get data => _data;
  int? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = _data;
    map['type'] = _type;
    return map;
  }

}