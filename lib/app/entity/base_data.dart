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

class UploadBindLabels {
  NameplatePhotoUpload? cavityPhoto;
  List<String>? bindLabels;
  NameplatePhotoUpload? nameplatePhoto;
  NameplatePhotoUpload? overallPhoto;

  UploadBindLabels(
      {this.cavityPhoto,
      this.bindLabels,
      this.nameplatePhoto,
      this.overallPhoto});

  UploadBindLabels.fromJson(Map<String, dynamic> json) {
    cavityPhoto = json['cavityPhoto'] != null
        ? new NameplatePhotoUpload.fromJson(json['cavityPhoto'])
        : null;
    bindLabels = json["bindLabels"] == null
        ? null
        : List<String>.from(json["bindLabels"]);
    nameplatePhoto = json['nameplatePhoto'] != null
        ? new NameplatePhotoUpload.fromJson(json['nameplatePhoto'])
        : null;
    overallPhoto = json['overallPhoto'] != null
        ? new NameplatePhotoUpload.fromJson(json['overallPhoto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cavityPhoto != null) {
      data['cavityPhoto'] = this.cavityPhoto!.toJson();
    }
    data['bindLabels'] = this.bindLabels;
    if (this.nameplatePhoto != null) {
      data['nameplatePhoto'] = this.nameplatePhoto!.toJson();
    }

    if (this.overallPhoto != null) {
      data['overallPhoto'] = this.overallPhoto!.toJson();
    }
    return data;
  }
}

class NameplatePhotoUpload {
  String? docComments;
  String? documentName;
  String? downloadType;
  String? fileSize;
  String? fileSuffix;
  String? fullPath;

  NameplatePhotoUpload(
      {this.docComments,
      this.documentName,
      this.downloadType,
      this.fileSize,
      this.fileSuffix,
      this.fullPath});

  NameplatePhotoUpload.fromJson(Map<String, dynamic> json) {
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
