///模具绑定实体类
///

//模具绑定列表
class MouldBindList {
  MouldData? data;
  String? message;
  int? state;

  MouldBindList({this.data, this.message, this.state});

  MouldBindList.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new MouldData.fromJson(json['data']) : null;
    message = json['message'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['state'] = this.state;
    return data;
  }
}

class MouldData {
  int? finished;
  List<MouldFinishedTaskList>? finishedTaskList;
  int? unfinished;
  List<MouldFinishedTaskList>? unfinishedTaskList;

  MouldData(
      {this.finished,
      this.finishedTaskList,
      this.unfinished,
      this.unfinishedTaskList});

  MouldData.fromJson(Map<String, dynamic> json) {
    finished = json['finished'];
    if (json['finishedTaskList'] != null) {
      finishedTaskList = <MouldFinishedTaskList>[];
      json['finishedTaskList'].forEach((v) {
        finishedTaskList!.add(new MouldFinishedTaskList.fromJson(v));
      });
    }
    unfinished = json['unfinished'];
    if (json['unfinishedTaskList'] != null) {
      unfinishedTaskList = <MouldFinishedTaskList>[];
      json['unfinishedTaskList'].forEach((v) {
        unfinishedTaskList!.add(new MouldFinishedTaskList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['finished'] = this.finished;
    if (this.finishedTaskList != null) {
      data['finishedTaskList'] =
          this.finishedTaskList!.map((v) => v.toJson()).toList();
    }
    data['unfinished'] = this.unfinished;
    if (this.unfinishedTaskList != null) {
      data['unfinishedTaskList'] =
          this.unfinishedTaskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MouldFinishedTaskList {
  String? distributionTime;
  String? finishedTime;
  List<MouldList>? mouldList;
  String? poNo;
  String? taskNo;

  ///任务类型(0为支付，1为标签替换)
  int? taskType;
  int? totalMoulds;

  MouldFinishedTaskList(
      {this.distributionTime,
      this.finishedTime,
      this.mouldList,
      this.poNo,
      this.taskNo,
      this.taskType,
      this.totalMoulds});

  MouldFinishedTaskList.fromJson(Map<String, dynamic> json) {
    distributionTime = json['distributionTime'];
    finishedTime = json['finishedTime'];
    if (json['mouldList'] != null) {
      mouldList = <MouldList>[];
      json['mouldList'].forEach((v) {
        mouldList!.add(new MouldList.fromJson(v));
      });
    }
    poNo = json['poNo'];
    taskNo = json['taskNo'];
    taskType = json['taskType'];
    totalMoulds = json['totalMoulds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributionTime'] = this.distributionTime;
    data['finishedTime'] = this.finishedTime;
    if (this.mouldList != null) {
      data['mouldList'] = this.mouldList!.map((v) => v.toJson()).toList();
    }
    data['poNo'] = this.poNo;
    data['taskNo'] = this.taskNo;
    data['taskType'] = this.taskType;
    data['totalMoulds'] = this.totalMoulds;
    return data;
  }
}

class MouldList {
  int? assetBindTaskId;
  String? assetLifespan;
  String? assetNo;
  List<BindLabels>? bindLabels;
  int? bindStatus;
  String? bindStatusText;
  int? labelReplaceTaskId;
  int? labelType;
  double? lat;
  double? lng;
  String? manufactureUnits;
  String? moldName;
  String? moldNo;
  String? poNo;
  String? remark;
  String? taskNo;
  String? toolingName;
  String? toolingSize;
  String? toolingType;
  String? toolingWeight;
  String? usedUnits;
  String? vehicle;

  MouldList(
      {this.assetBindTaskId,
      this.assetLifespan,
      this.assetNo,
      this.bindLabels,
      this.bindStatus,
      this.bindStatusText,
      this.labelReplaceTaskId,
      this.labelType,
      this.lat,
      this.lng,
      this.manufactureUnits,
      this.moldName,
      this.moldNo,
      this.poNo,
      this.remark,
      this.taskNo,
      this.toolingName,
      this.toolingSize,
      this.toolingType,
      this.toolingWeight,
      this.usedUnits,
      this.vehicle});

  MouldList.fromJson(Map<String, dynamic> json) {
    assetBindTaskId = json['assetBindTaskId'];
    assetLifespan = json['assetLifespan'];
    assetNo = json['assetNo'];
    if (json['bindLabels'] != null) {
      bindLabels = <BindLabels>[];
      json['bindLabels'].forEach((v) {
        bindLabels!.add(new BindLabels.fromJson(v));
      });
    }
    bindStatus = json['bindStatus'];
    bindStatusText = json['bindStatusText'];
    labelReplaceTaskId = json['labelReplaceTaskId'];
    labelType = json['labelType'];
    lat = json['lat'];
    lng = json['lng'];
    manufactureUnits = json['manufactureUnits'];
    moldName = json['moldName'];
    moldNo = json['moldNo'];
    poNo = json['poNo'];
    remark = json['remark'];
    taskNo = json['taskNo'];
    toolingName = json['toolingName'];
    toolingSize = json['toolingSize'];
    toolingType = json['toolingType'];
    toolingWeight = json['toolingWeight'];
    usedUnits = json['usedUnits'];
    vehicle = json['vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assetBindTaskId'] = this.assetBindTaskId;
    data['assetLifespan'] = this.assetLifespan;
    data['assetNo'] = this.assetNo;
    if (this.bindLabels != null) {
      data['bindLabels'] = this.bindLabels!.map((v) => v.toJson()).toList();
    }
    data['bindStatus'] = this.bindStatus;
    data['labelReplaceTaskId'] = this.labelReplaceTaskId;
    data['labelType'] = this.labelType;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['manufactureUnits'] = this.manufactureUnits;
    data['moldName'] = this.moldName;
    data['moldNo'] = this.moldNo;
    data['poNo'] = this.poNo;
    data['remark'] = this.remark;
    data['taskNo'] = this.taskNo;
    data['toolingName'] = this.toolingName;
    data['toolingSize'] = this.toolingSize;
    data['toolingType'] = this.toolingType;
    data['toolingWeight'] = this.toolingWeight;
    data['usedUnits'] = this.usedUnits;
    data['vehicle'] = this.vehicle;
    return data;
  }
}

class BindLabels {
  NameplatePhoto? cavityPhoto;
  String? labelNo;
  NameplatePhoto? nameplatePhoto;
  NameplatePhoto? overallPhoto;

  BindLabels(
      {this.cavityPhoto, this.labelNo, this.nameplatePhoto, this.overallPhoto});

  BindLabels.fromJson(Map<String, dynamic> json) {
    cavityPhoto = json['cavityPhoto'] != null
        ? new NameplatePhoto.fromJson(json['cavityPhoto'])
        : null;
    labelNo = json['labelNo'];
    nameplatePhoto = json['nameplatePhoto'] != null
        ? new NameplatePhoto.fromJson(json['nameplatePhoto'])
        : null;
    overallPhoto = json['overallPhoto'] != null
        ? new NameplatePhoto.fromJson(json['overallPhoto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cavityPhoto != null) {
      data['cavityPhoto'] = this.cavityPhoto!.toJson();
    }
    data['labelNo'] = this.labelNo;
    if (this.nameplatePhoto != null) {
      data['nameplatePhoto'] = this.nameplatePhoto!.toJson();
    }

    if (this.overallPhoto != null) {
      data['overallPhoto'] = this.overallPhoto!.toJson();
    }
    return data;
  }
}

class NameplatePhoto {
  String? docComments;
  String? documentName;
  String? downloadType;
  String? fileSize;
  String? fileSuffix;
  String? fullPath;

  NameplatePhoto(
      {this.docComments,
      this.documentName,
      this.downloadType,
      this.fileSize,
      this.fileSuffix,
      this.fullPath});

  NameplatePhoto.fromJson(Map<String, dynamic> json) {
    docComments = json['docComments'];
    documentName = json['documentName'];
    downloadType = json['downloadType'];
    fileSize = json['fileSize'];
    fileSuffix = json['fileSuffix'];
    fullPath = json['fullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docComments'] = this.docComments;
    data['documentName'] = this.documentName;
    data['downloadType'] = this.downloadType;
    data['fileSize'] = this.fileSize;
    data['fileSuffix'] = this.fileSuffix;
    data['fullPath'] = this.fullPath;
    return data;
  }
}
