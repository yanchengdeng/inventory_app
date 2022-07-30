/// data : {"finished":0,"finishedList":[{"distributionTime":"2022-06-11 12:17:46","endDate":"2021-05-04","finishedTime":"2022-06-18 12:17:46","inventoryTotal":1,"inventoryType":1,"list":[{"assetInventoryDetailId":1,"assetInventoryStatus":1,"assetName":"天窗边框模具","assetNo":"PO123456-001-M","inventoryTaskId":1,"labelNo":"XP000000001,XP000000002","toolingType":"F","usedArea":"上海金桥"}],"taskNo":"I20220317914"}],"unfinished":1,"unfinishedList":[{"distributionTime":"2022-06-11 12:17:46","endDate":"2021-05-04","finishedTime":"2022-06-18 12:17:46","inventoryTotal":1,"inventoryType":1,"list":[{"assetInventoryDetailId":1,"assetInventoryStatus":1,"assetName":"天窗边框模具","assetNo":"PO123456-001-M","inventoryTaskId":1,"labelNo":"XP000000001,XP000000002","toolingType":"F","usedArea":"上海金桥"}],"taskNo":"I20220317914"}]}
/// message : ""
/// state : 1

class InventoryList {
  InventoryList({
    InventroyData? data,
    String? message,
    int? state,
  }) {
    _data = data;
    _message = message;
    _state = state;
  }

  InventoryList.fromJson(dynamic json) {
    _data = json['data'] != null ? InventroyData.fromJson(json['data']) : null;
    _message = json['message'];
    _state = json['state'];
  }
  InventroyData? _data;
  String? _message;
  int? _state;
  InventoryList copyWith({
    InventroyData? data,
    String? message,
    int? state,
  }) =>
      InventoryList(
        data: data ?? _data,
        message: message ?? _message,
        state: state ?? _state,
      );
  InventroyData? get data => _data;
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

/// finished : 0
/// finishedList : [{"distributionTime":"2022-06-11 12:17:46","endDate":"2021-05-04","finishedTime":"2022-06-18 12:17:46","inventoryTotal":1,"inventoryType":1,"list":[{"assetInventoryDetailId":1,"assetInventoryStatus":1,"assetName":"天窗边框模具","assetNo":"PO123456-001-M","inventoryTaskId":1,"labelNo":"XP000000001,XP000000002","toolingType":"F","usedArea":"上海金桥"}],"taskNo":"I20220317914"}]
/// unfinished : 1
/// unfinishedList : [{"distributionTime":"2022-06-11 12:17:46","endDate":"2021-05-04","finishedTime":"2022-06-18 12:17:46","inventoryTotal":1,"inventoryType":1,"list":[{"assetInventoryDetailId":1,"assetInventoryStatus":1,"assetName":"天窗边框模具","assetNo":"PO123456-001-M","inventoryTaskId":1,"labelNo":"XP000000001,XP000000002","toolingType":"F","usedArea":"上海金桥"}],"taskNo":"I20220317914"}]

class InventroyData {
  InventroyData({
    int? finished,
    List<InventoryFinishedList>? finishedList,
    int? unfinished,
    List<InventoryFinishedList>? unfinishedList,
  }) {
    _finished = finished;
    _finishedList = finishedList;
    _unfinished = unfinished;
    _unfinishedList = unfinishedList;
  }

  InventroyData.fromJson(dynamic json) {
    _finished = json['finished'];
    if (json['finishedList'] != null) {
      _finishedList = [];
      json['finishedList'].forEach((v) {
        _finishedList?.add(InventoryFinishedList.fromJson(v));
      });
    }
    _unfinished = json['unfinished'];
    if (json['unfinishedList'] != null) {
      _unfinishedList = [];
      json['unfinishedList'].forEach((v) {
        _unfinishedList?.add(InventoryFinishedList.fromJson(v));
      });
    }
  }
  int? _finished;
  List<InventoryFinishedList>? _finishedList;
  int? _unfinished;
  List<InventoryFinishedList>? _unfinishedList;
  InventroyData copyWith({
    int? finished,
    List<InventoryFinishedList>? finishedList,
    int? unfinished,
    List<InventoryFinishedList>? unfinishedList,
  }) =>
      InventroyData(
        finished: finished ?? _finished,
        finishedList: finishedList ?? _finishedList,
        unfinished: unfinished ?? _unfinished,
        unfinishedList: unfinishedList ?? _unfinishedList,
      );
  int? get finished => _finished;
  List<InventoryFinishedList>? get finishedList => _finishedList;
  int? get unfinished => _unfinished;
  List<InventoryFinishedList>? get unfinishedList => _unfinishedList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['finished'] = _finished;
    if (_finishedList != null) {
      map['finishedList'] = _finishedList?.map((v) => v.toJson()).toList();
    }
    map['unfinished'] = _unfinished;
    if (_unfinishedList != null) {
      map['unfinishedList'] = _unfinishedList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// distributionTime : "2022-06-11 12:17:46"
/// endDate : "2021-05-04"
/// finishedTime : "2022-06-18 12:17:46"
/// inventoryTotal : 1
/// inventoryType : 1
/// list : [{"assetInventoryDetailId":1,"assetInventoryStatus":1,"assetName":"天窗边框模具","assetNo":"PO123456-001-M","inventoryTaskId":1,"labelNo":"XP000000001,XP000000002","toolingType":"F","usedArea":"上海金桥"}]
/// taskNo : "I20220317914"

class InventoryFinishedList {
  InventoryFinishedList({
    String? distributionTime,
    String? endDate,
    String? finishedTime,
    int? inventoryTotal,
    int? inventoryType,
    String? inventoryTypeText,
    List<ItemList>? list,
    String? taskNo,
  }) {
    _distributionTime = distributionTime;
    _endDate = endDate;
    _finishedTime = finishedTime;
    _inventoryTotal = inventoryTotal;
    _inventoryType = inventoryType;
    _inventoryTypeText = inventoryTypeText;
    _list = list;
    _taskNo = taskNo;
  }

  InventoryFinishedList.fromJson(dynamic json) {
    _distributionTime = json['distributionTime'];
    _endDate = json['endDate'];
    _finishedTime = json['finishedTime'];
    _inventoryTotal = json['inventoryTotal'];
    _inventoryType = json['inventoryType'];
    _inventoryTypeText = json['inventoryTypeText'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(ItemList.fromJson(v));
      });
    }
    _taskNo = json['taskNo'];
  }
  String? _distributionTime;
  String? _endDate;
  String? _finishedTime;
  int? _inventoryTotal;
  int? _inventoryType;
  String? _inventoryTypeText;
  List<ItemList>? _list;
  String? _taskNo;
  InventoryFinishedList copyWith({
    String? distributionTime,
    String? endDate,
    String? finishedTime,
    int? inventoryTotal,
    int? inventoryType,
    String? inventoryTypeText,
    List<ItemList>? list,
    String? taskNo,
  }) =>
      InventoryFinishedList(
        distributionTime: distributionTime ?? _distributionTime,
        endDate: endDate ?? _endDate,
        finishedTime: finishedTime ?? _finishedTime,
        inventoryTotal: inventoryTotal ?? _inventoryTotal,
        inventoryType: inventoryType ?? _inventoryType,
        inventoryTypeText: inventoryTypeText ?? _inventoryTypeText,
        list: list ?? _list,
        taskNo: taskNo ?? _taskNo,
      );
  String? get distributionTime => _distributionTime;
  String? get endDate => _endDate;
  String? get finishedTime => _finishedTime;
  int? get inventoryTotal => _inventoryTotal;
  int? get inventoryType => _inventoryType;
  String? get inventoryTypeText => _inventoryTypeText;
  List<ItemList>? get list => _list;
  String? get taskNo => _taskNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['distributionTime'] = _distributionTime;
    map['endDate'] = _endDate;
    map['finishedTime'] = _finishedTime;
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

/// assetInventoryDetailId : 1
/// assetInventoryStatus : 1
/// assetName : "天窗边框模具"
/// assetNo : "PO123456-001-M"
/// inventoryTaskId : 1
/// labelNo : "XP000000001,XP000000002"
/// toolingType : "F"
/// usedArea : "上海金桥"

class ItemList {
  ItemList({
    int? assetInventoryDetailId,
    int? assetInventoryStatus,
    String? assetName,
    String? assetNo,
    int? inventoryTaskId,
    String? labelNo,
    String? toolingType,
    String? usedArea,
  }) {
    _assetInventoryDetailId = assetInventoryDetailId;
    _assetInventoryStatus = assetInventoryStatus;
    _assetName = assetName;
    _assetNo = assetNo;
    _inventoryTaskId = inventoryTaskId;
    _labelNo = labelNo;
    _toolingType = toolingType;
    _usedArea = usedArea;
  }

  ItemList.fromJson(dynamic json) {
    _assetInventoryDetailId = json['assetInventoryDetailId'];
    _assetInventoryStatus = json['assetInventoryStatus'];
    _assetName = json['assetName'];
    _assetNo = json['assetNo'];
    _inventoryTaskId = json['inventoryTaskId'];
    _labelNo = json['labelNo'];
    _toolingType = json['toolingType'];
    _usedArea = json['usedArea'];
  }
  int? _assetInventoryDetailId;
  int? _assetInventoryStatus;
  String? _assetName;
  String? _assetNo;
  int? _inventoryTaskId;
  String? _labelNo;
  String? _toolingType;
  String? _usedArea;
  ItemList copyWith({
    int? assetInventoryDetailId,
    int? assetInventoryStatus,
    String? assetName,
    String? assetNo,
    int? inventoryTaskId,
    String? labelNo,
    String? toolingType,
    String? usedArea,
  }) =>
      ItemList(
        assetInventoryDetailId:
            assetInventoryDetailId ?? _assetInventoryDetailId,
        assetInventoryStatus: assetInventoryStatus ?? _assetInventoryStatus,
        assetName: assetName ?? _assetName,
        assetNo: assetNo ?? _assetNo,
        inventoryTaskId: inventoryTaskId ?? _inventoryTaskId,
        labelNo: labelNo ?? _labelNo,
        toolingType: toolingType ?? _toolingType,
        usedArea: usedArea ?? _usedArea,
      );
  int? get assetInventoryDetailId => _assetInventoryDetailId;
  int? get assetInventoryStatus => _assetInventoryStatus;
  String? get assetName => _assetName;
  String? get assetNo => _assetNo;
  int? get inventoryTaskId => _inventoryTaskId;
  String? get labelNo => _labelNo;
  String? get toolingType => _toolingType;
  String? get usedArea => _usedArea;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assetInventoryDetailId'] = _assetInventoryDetailId;
    map['assetInventoryStatus'] = _assetInventoryStatus;
    map['assetName'] = _assetName;
    map['assetNo'] = _assetNo;
    map['inventoryTaskId'] = _inventoryTaskId;
    map['labelNo'] = _labelNo;
    map['toolingType'] = _toolingType;
    map['usedArea'] = _usedArea;
    return map;
  }
}
