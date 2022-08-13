/// data : [{"distributionTime":"2022-07-18 13:37:10","distributionTimeStamp":1658122630000,"endDate":"2022-07-19","finishedTime":"","inventoryTotal":1,"inventoryType":1,"inventoryTypeText":"年度盘点","list":[{"assetInventoryDetailId":769,"assetInventoryStatus":0,"assetName":"火星塞","assetNo":"PO218912-1657547716-F","distributionTime":"2022-07-18 13:37:10","distributionTimeStamp":1658122630000,"inventoryNo":"I20220713207","labelNo":"","toolingType":"F","usedArea":"上海浦东"}],"taskNo":"I20220713207"},{"distributionTime":"2022-07-11 21:55:09","distributionTimeStamp":1657547709000,"endDate":"2022-07-31","finishedTime":"","inventoryTotal":1,"inventoryType":2,"inventoryTypeText":"临时盘点","list":[{"assetInventoryDetailId":62,"assetInventoryStatus":0,"assetName":"卤素头灯","assetNo":"PO195730-1657547708-M","distributionTime":"2022-07-11 21:55:09","distributionTimeStamp":1657547709000,"inventoryNo":"I20220711979","labelNo":"XP199_1657547709,XP199_1657547710,XP199_1657547711","toolingType":"M","usedArea":"上海浦东"}],"taskNo":"I20220711979"},{"distributionTime":"2022-07-11 21:55:02","distributionTimeStamp":1657547702000,"endDate":"2022-07-31","finishedTime":"","inventoryTotal":1,"inventoryType":2,"inventoryTypeText":"临时盘点","list":[{"assetInventoryDetailId":60,"assetInventoryStatus":0,"assetName":"万向接头","assetNo":"PO169912-1657547700-G","distributionTime":"2022-07-11 21:55:02","distributionTimeStamp":1657547702000,"inventoryNo":"I20220711812","labelNo":"XP197_1657547702,XP197_1657547703,XP197_1657547704","toolingType":"G","usedArea":"上海嘉定"}],"taskNo":"I20220711812"},{"distributionTime":"2022-07-11 21:55:00","distributionTimeStamp":1657547700000,"endDate":"2022-07-31","finishedTime":"","inventoryTotal":1,"inventoryType":1,"inventoryTypeText":"年度盘点","list":[{"assetInventoryDetailId":59,"assetInventoryStatus":0,"assetName":"爆震","assetNo":"PO152720-1657547698-F","distributionTime":"2022-07-11 21:55:00","distributionTimeStamp":1657547700000,"inventoryNo":"I20220711602","labelNo":"XP196_1657547700,XP196_1657547701,XP196_1657547702","toolingType":"F","usedArea":"上海金桥"}],"taskNo":"I20220711602"},{"distributionTime":"2022-07-11 21:54:58","distributionTimeStamp":1657547698000,"endDate":"2022-07-31","finishedTime":"","inventoryTotal":1,"inventoryType":1,"inventoryTypeText":"年度盘点","list":[{"assetInventoryDetailId":58,"assetInventoryStatus":0,"assetName":"储液器和干燥器","assetNo":"PO197982-1657547696-M","distributionTime":"2022-07-11 21:54:58","distributionTimeStamp":1657547698000,"inventoryNo":"I20220711765","labelNo":"XP195_1657547698,XP195_1657547699,XP195_1657547700","toolingType":"M","usedArea":"上海金桥"}],"taskNo":"I20220711765"},{"distributionTime":"2022-07-11 21:54:49","distributionTimeStamp":1657547689000,"endDate":"2022-07-31","finishedTime":"","inventoryTotal":1,"inventoryType":1,"inventoryTypeText":"年度盘点","list":[{"assetInventoryDetailId":54,"assetInventoryStatus":0,"assetName":"卤素头灯","assetNo":"PO139887-1657547688-G","distributionTime":"2022-07-11 21:54:49","distributionTimeStamp":1657547689000,"inventoryNo":"I20220711707","labelNo":"XP191_1657547689,XP191_1657547690,XP191_1657547691","toolingType":"G","usedArea":"上海嘉定"}],"taskNo":"I20220711707"},{"distributionTime":"2022-07-11 21:54:48","distributionTimeStamp":1657547688000,"endDate":"2022-07-31","finishedTime":"","inventoryTotal":1,"inventoryType":2,"inventoryTypeText":"临时盘点","list":[{"assetInventoryDetailId":53,"assetInventoryStatus":0,"assetName":"起动马达","assetNo":"PO186056-1657547686-G","distributionTime":"2022-07-11 21:54:48","distributionTimeStamp":1657547688000,"inventoryNo":"I20220711629","labelNo":"XP190_1657547688,XP190_1657547689,XP190_1657547690","toolingType":"G","usedArea":"上海嘉定"}],"taskNo":"I20220711629"}]
/// message : ""
/// state : 1

class InventoryData {
  InventoryData({
    List<InventoryFinishedList>? data,
    String? message,
    int? state,}){
    _data = data;
    _message = message;
    _state = state;
  }

  InventoryData.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(InventoryFinishedList.fromJson(v));
      });
    }
    _message = json['message'];
    _state = json['state'];
  }
  List<InventoryFinishedList>? _data;
  String? _message;
  int? _state;
  InventoryData copyWith({  List<InventoryFinishedList>? data,
    String? message,
    int? state,
  }) => InventoryData(  data: data ?? _data,
    message: message ?? _message,
    state: state ?? _state,
  );
  List<InventoryFinishedList>? get data => _data;
  String? get message => _message;
  int? get state => _state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    map['state'] = _state;
    return map;
  }

}

/// distributionTime : "2022-07-18 13:37:10"
/// distributionTimeStamp : 1658122630000
/// endDate : "2022-07-19"
/// finishedTime : ""
/// inventoryTotal : 1
/// inventoryType : 1
/// inventoryTypeText : "年度盘点"
/// list : [{"assetInventoryDetailId":769,"assetInventoryStatus":0,"assetName":"火星塞","assetNo":"PO218912-1657547716-F","distributionTime":"2022-07-18 13:37:10","distributionTimeStamp":1658122630000,"inventoryNo":"I20220713207","labelNo":"","toolingType":"F","usedArea":"上海浦东"}]
/// taskNo : "I20220713207"

class InventoryFinishedList {
  InventoryFinishedList({
    String? distributionTime,
    int? distributionTimeStamp,
    String? endDate,
    String? finishedTime,
    String? inventoryYear,
    int? inventoryTotal,
    int? inventoryType,
    String? inventoryTypeText,
    List<InventoryDetail>? list,
    String? taskNo,}){
    _distributionTime = distributionTime;
    _distributionTimeStamp = distributionTimeStamp;
    _endDate = endDate;
    _finishedTime = finishedTime;
    _inventoryYear = inventoryYear;
    _inventoryTotal = inventoryTotal;
    _inventoryType = inventoryType;
    _inventoryTypeText = inventoryTypeText;
    _list = list;
    _taskNo = taskNo;
  }

  InventoryFinishedList.fromJson(dynamic json) {
    _distributionTime = json['distributionTime'];
    _distributionTimeStamp = json['distributionTimeStamp'];
    _endDate = json['endDate'];
    _finishedTime = json['finishedTime'];
    _inventoryYear = json['inventoryYear'];
    _inventoryTotal = json['inventoryTotal'];
    _inventoryType = json['inventoryType'];
    _inventoryTypeText = json['inventoryTypeText'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(InventoryDetail.fromJson(v));
      });
    }
    _taskNo = json['taskNo'];
  }
  String? _distributionTime;
  int? _distributionTimeStamp;
  String? _endDate;
  String? _finishedTime;
  String? _inventoryYear;
  int? _inventoryTotal;
  int? _inventoryType;
  String? _inventoryTypeText;
  List<InventoryDetail>? _list;
  String? _taskNo;
  InventoryFinishedList copyWith({  String? distributionTime,
    int? distributionTimeStamp,
    String? endDate,
    String? finishedTime,
    String? inventoryYear,
    int? inventoryTotal,
    int? inventoryType,
    String? inventoryTypeText,
    List<InventoryDetail>? list,
    String? taskNo,
  }) => InventoryFinishedList(  distributionTime: distributionTime ?? _distributionTime,
    distributionTimeStamp: distributionTimeStamp ?? _distributionTimeStamp,
    endDate: endDate ?? _endDate,
    finishedTime: finishedTime ?? _finishedTime,
    inventoryYear : inventoryYear ??_inventoryYear,
    inventoryTotal: inventoryTotal ?? _inventoryTotal,
    inventoryType: inventoryType ?? _inventoryType,
    inventoryTypeText: inventoryTypeText ?? _inventoryTypeText,
    list: list ?? _list,
    taskNo: taskNo ?? _taskNo,
  );
  String? get distributionTime => _distributionTime;
  int? get distributionTimeStamp => _distributionTimeStamp;
  String? get endDate => _endDate;
  String? get finishedTime => _finishedTime;
  String? get inventoryYear => _inventoryYear;
  int? get inventoryTotal => _inventoryTotal;
  int? get inventoryType => _inventoryType;
  String? get inventoryTypeText => _inventoryTypeText;
  List<InventoryDetail>? get list => _list;
  String? get taskNo => _taskNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['distributionTime'] = _distributionTime;
    map['distributionTimeStamp'] = _distributionTimeStamp;
    map['endDate'] = _endDate;
    map['finishedTime'] = _finishedTime;
    map['inventoryYear'] = _inventoryYear;
    map['inventoryTotal'] = _inventoryTotal;
    map['inventoryType'] = _inventoryType;
    map['inventoryTypeText'] = _inventoryTypeText;
    if (_list != null) {
      map['list'] = _list?.map((v) => v.toJson()).toList();
    }
    map['taskNo'] = _taskNo;
    return map;
  }

}

/// assetInventoryDetailId : 769
/// assetInventoryStatus : 0
/// assetName : "火星塞"
/// assetNo : "PO218912-1657547716-F"
/// distributionTime : "2022-07-18 13:37:10"
/// distributionTimeStamp : 1658122630000
/// inventoryNo : "I20220713207"
/// labelNo : ""
/// toolingType : "F"
/// usedArea : "上海浦东"

class InventoryDetail {
  InventoryDetail({
    int? assetInventoryDetailId,
    int? assetInventoryStatus,
    String? assetName,
    String? assetNo,
    String? distributionTime,
    int? distributionTimeStamp,
    String? inventoryNo,
    String? labelNo,
    String? toolingType,
    String? usedArea,}){
    _assetInventoryDetailId = assetInventoryDetailId;
    _assetInventoryStatus = assetInventoryStatus;
    _assetName = assetName;
    _assetNo = assetNo;
    _distributionTime = distributionTime;
    _distributionTimeStamp = distributionTimeStamp;
    _inventoryNo = inventoryNo;
    _labelNo = labelNo;
    _toolingType = toolingType;
    _usedArea = usedArea;
  }

  InventoryDetail.fromJson(dynamic json) {
    _assetInventoryDetailId = json['assetInventoryDetailId'];
    _assetInventoryStatus = json['assetInventoryStatus'];
    _assetName = json['assetName'];
    _assetNo = json['assetNo'];
    _distributionTime = json['distributionTime'];
    _distributionTimeStamp = json['distributionTimeStamp'];
    _inventoryNo = json['inventoryNo'];
    _labelNo = json['labelNo'];
    _toolingType = json['toolingType'];
    _usedArea = json['usedArea'];
  }
  int? _assetInventoryDetailId;
  int? _assetInventoryStatus;
  String? _assetName;
  String? _assetNo;
  String? _distributionTime;
  int? _distributionTimeStamp;
  String? _inventoryNo;
  String? _labelNo;
  String? _toolingType;
  String? _usedArea;
  InventoryDetail copyWith({  int? assetInventoryDetailId,
    int? assetInventoryStatus,
    String? assetName,
    String? assetNo,
    String? distributionTime,
    int? distributionTimeStamp,
    String? inventoryNo,
    String? labelNo,
    String? toolingType,
    String? usedArea,
  }) => InventoryDetail(  assetInventoryDetailId: assetInventoryDetailId ?? _assetInventoryDetailId,
    assetInventoryStatus: assetInventoryStatus ?? _assetInventoryStatus,
    assetName: assetName ?? _assetName,
    assetNo: assetNo ?? _assetNo,
    distributionTime: distributionTime ?? _distributionTime,
    distributionTimeStamp: distributionTimeStamp ?? _distributionTimeStamp,
    inventoryNo: inventoryNo ?? _inventoryNo,
    labelNo: labelNo ?? _labelNo,
    toolingType: toolingType ?? _toolingType,
    usedArea: usedArea ?? _usedArea,
  );
  int? get assetInventoryDetailId => _assetInventoryDetailId;
  int? get assetInventoryStatus => _assetInventoryStatus;
  String? get assetName => _assetName;
  String? get assetNo => _assetNo;
  String? get distributionTime => _distributionTime;
  int? get distributionTimeStamp => _distributionTimeStamp;
  String? get inventoryNo => _inventoryNo;
  String? get labelNo => _labelNo;
  String? get toolingType => _toolingType;
  String? get usedArea => _usedArea;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assetInventoryDetailId'] = _assetInventoryDetailId;
    map['assetInventoryStatus'] = _assetInventoryStatus;
    map['assetName'] = _assetName;
    map['assetNo'] = _assetNo;
    map['distributionTime'] = _distributionTime;
    map['distributionTimeStamp'] = _distributionTimeStamp;
    map['inventoryNo'] = _inventoryNo;
    map['labelNo'] = _labelNo;
    map['toolingType'] = _toolingType;
    map['usedArea'] = _usedArea;
    return map;
  }

}