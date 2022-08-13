/// label : "fsd"
/// flag : 1 :
/// flag  : 1 rfid 读取  2 扫码读取

class LabelInfo {
  LabelInfo({
      String? label, 
      int? flag,}){
    _label = label;
    _flag = flag;
}

  LabelInfo.fromJson(dynamic json) {
    _label = json['label'];
    _flag = json['flag'];
  }
  String? _label;
  int? _flag;
LabelInfo copyWith({  String? label,
  int? flag,
}) => LabelInfo(  label: label ?? _label,
  flag: flag ?? _flag,
);
  String? get label => _label;
  int? get flag => _flag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['flag'] = _flag;
    return map;
  }

}