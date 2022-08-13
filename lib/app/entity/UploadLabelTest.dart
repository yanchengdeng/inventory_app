import 'dart:convert';
/// address : "上海市浦东新区曹路镇金穗路775号"
/// bindLabels : ["XP000000001","XP000000002"]
/// cavityPhoto : {"docComments":"小刘现场拍摄","documentName":"照片a","downloadType":"url","fileSize":12344554,"fileSuffix":"jpg","fullPath":"/path/to/file"}
/// labelType : 1
/// lat : 123.45678
/// lng : 123.45678
/// nameplatePhoto : {"docComments":"小刘现场拍摄","documentName":"照片a","downloadType":"url","fileSize":12344554,"fileSuffix":"jpg","fullPath":"/path/to/file"}
/// overallPhoto : {"docComments":"小刘现场拍摄","documentName":"照片a","downloadType":"url","fileSize":12344554,"fileSuffix":"jpg","fullPath":"/path/to/file"}

UploadLabelTest uploadLabelTestFromJson(String str) => UploadLabelTest.fromJson(json.decode(str));
String uploadLabelTestToJson(UploadLabelTest data) => json.encode(data.toJson());
class UploadLabelTest {
  UploadLabelTest({
      String? address, 
      List<String>? bindLabels, 
      CavityPhoto? cavityPhoto, 
      int? labelType, 
      double? lat, 
      double? lng, 
      NameplatePhoto? nameplatePhoto, 
      OverallPhoto? overallPhoto,}){
    _address = address;
    _bindLabels = bindLabels;
    _cavityPhoto = cavityPhoto;
    _labelType = labelType;
    _lat = lat;
    _lng = lng;
    _nameplatePhoto = nameplatePhoto;
    _overallPhoto = overallPhoto;
}

  UploadLabelTest.fromJson(dynamic json) {
    _address = json['address'];
    _bindLabels = json['bindLabels'] != null ? json['bindLabels'].cast<String>() : [];
    _cavityPhoto = json['cavityPhoto'] != null ? CavityPhoto.fromJson(json['cavityPhoto']) : null;
    _labelType = json['labelType'];
    _lat = json['lat'];
    _lng = json['lng'];
    _nameplatePhoto = json['nameplatePhoto'] != null ? NameplatePhoto.fromJson(json['nameplatePhoto']) : null;
    _overallPhoto = json['overallPhoto'] != null ? OverallPhoto.fromJson(json['overallPhoto']) : null;
  }
  String? _address;
  List<String>? _bindLabels;
  CavityPhoto? _cavityPhoto;
  int? _labelType;
  double? _lat;
  double? _lng;
  NameplatePhoto? _nameplatePhoto;
  OverallPhoto? _overallPhoto;
UploadLabelTest copyWith({  String? address,
  List<String>? bindLabels,
  CavityPhoto? cavityPhoto,
  int? labelType,
  double? lat,
  double? lng,
  NameplatePhoto? nameplatePhoto,
  OverallPhoto? overallPhoto,
}) => UploadLabelTest(  address: address ?? _address,
  bindLabels: bindLabels ?? _bindLabels,
  cavityPhoto: cavityPhoto ?? _cavityPhoto,
  labelType: labelType ?? _labelType,
  lat: lat ?? _lat,
  lng: lng ?? _lng,
  nameplatePhoto: nameplatePhoto ?? _nameplatePhoto,
  overallPhoto: overallPhoto ?? _overallPhoto,
);
  String? get address => _address;
  List<String>? get bindLabels => _bindLabels;
  CavityPhoto? get cavityPhoto => _cavityPhoto;
  int? get labelType => _labelType;
  double? get lat => _lat;
  double? get lng => _lng;
  NameplatePhoto? get nameplatePhoto => _nameplatePhoto;
  OverallPhoto? get overallPhoto => _overallPhoto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['bindLabels'] = _bindLabels;
    if (_cavityPhoto != null) {
      map['cavityPhoto'] = _cavityPhoto?.toJson();
    }
    map['labelType'] = _labelType;
    map['lat'] = _lat;
    map['lng'] = _lng;
    if (_nameplatePhoto != null) {
      map['nameplatePhoto'] = _nameplatePhoto?.toJson();
    }
    if (_overallPhoto != null) {
      map['overallPhoto'] = _overallPhoto?.toJson();
    }
    return map;
  }

}

/// docComments : "小刘现场拍摄"
/// documentName : "照片a"
/// downloadType : "url"
/// fileSize : 12344554
/// fileSuffix : "jpg"
/// fullPath : "/path/to/file"

OverallPhoto overallPhotoFromJson(String str) => OverallPhoto.fromJson(json.decode(str));
String overallPhotoToJson(OverallPhoto data) => json.encode(data.toJson());
class OverallPhoto {
  OverallPhoto({
      String? docComments, 
      String? documentName, 
      String? downloadType, 
      int? fileSize, 
      String? fileSuffix, 
      String? fullPath,}){
    _docComments = docComments;
    _documentName = documentName;
    _downloadType = downloadType;
    _fileSize = fileSize;
    _fileSuffix = fileSuffix;
    _fullPath = fullPath;
}

  OverallPhoto.fromJson(dynamic json) {
    _docComments = json['docComments'];
    _documentName = json['documentName'];
    _downloadType = json['downloadType'];
    _fileSize = json['fileSize'];
    _fileSuffix = json['fileSuffix'];
    _fullPath = json['fullPath'];
  }
  String? _docComments;
  String? _documentName;
  String? _downloadType;
  int? _fileSize;
  String? _fileSuffix;
  String? _fullPath;
OverallPhoto copyWith({  String? docComments,
  String? documentName,
  String? downloadType,
  int? fileSize,
  String? fileSuffix,
  String? fullPath,
}) => OverallPhoto(  docComments: docComments ?? _docComments,
  documentName: documentName ?? _documentName,
  downloadType: downloadType ?? _downloadType,
  fileSize: fileSize ?? _fileSize,
  fileSuffix: fileSuffix ?? _fileSuffix,
  fullPath: fullPath ?? _fullPath,
);
  String? get docComments => _docComments;
  String? get documentName => _documentName;
  String? get downloadType => _downloadType;
  int? get fileSize => _fileSize;
  String? get fileSuffix => _fileSuffix;
  String? get fullPath => _fullPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['docComments'] = _docComments;
    map['documentName'] = _documentName;
    map['downloadType'] = _downloadType;
    map['fileSize'] = _fileSize;
    map['fileSuffix'] = _fileSuffix;
    map['fullPath'] = _fullPath;
    return map;
  }

}

/// docComments : "小刘现场拍摄"
/// documentName : "照片a"
/// downloadType : "url"
/// fileSize : 12344554
/// fileSuffix : "jpg"
/// fullPath : "/path/to/file"

NameplatePhoto nameplatePhotoFromJson(String str) => NameplatePhoto.fromJson(json.decode(str));
String nameplatePhotoToJson(NameplatePhoto data) => json.encode(data.toJson());
class NameplatePhoto {
  NameplatePhoto({
      String? docComments, 
      String? documentName, 
      String? downloadType, 
      int? fileSize, 
      String? fileSuffix, 
      String? fullPath,}){
    _docComments = docComments;
    _documentName = documentName;
    _downloadType = downloadType;
    _fileSize = fileSize;
    _fileSuffix = fileSuffix;
    _fullPath = fullPath;
}

  NameplatePhoto.fromJson(dynamic json) {
    _docComments = json['docComments'];
    _documentName = json['documentName'];
    _downloadType = json['downloadType'];
    _fileSize = json['fileSize'];
    _fileSuffix = json['fileSuffix'];
    _fullPath = json['fullPath'];
  }
  String? _docComments;
  String? _documentName;
  String? _downloadType;
  int? _fileSize;
  String? _fileSuffix;
  String? _fullPath;
NameplatePhoto copyWith({  String? docComments,
  String? documentName,
  String? downloadType,
  int? fileSize,
  String? fileSuffix,
  String? fullPath,
}) => NameplatePhoto(  docComments: docComments ?? _docComments,
  documentName: documentName ?? _documentName,
  downloadType: downloadType ?? _downloadType,
  fileSize: fileSize ?? _fileSize,
  fileSuffix: fileSuffix ?? _fileSuffix,
  fullPath: fullPath ?? _fullPath,
);
  String? get docComments => _docComments;
  String? get documentName => _documentName;
  String? get downloadType => _downloadType;
  int? get fileSize => _fileSize;
  String? get fileSuffix => _fileSuffix;
  String? get fullPath => _fullPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['docComments'] = _docComments;
    map['documentName'] = _documentName;
    map['downloadType'] = _downloadType;
    map['fileSize'] = _fileSize;
    map['fileSuffix'] = _fileSuffix;
    map['fullPath'] = _fullPath;
    return map;
  }

}

/// docComments : "小刘现场拍摄"
/// documentName : "照片a"
/// downloadType : "url"
/// fileSize : 12344554
/// fileSuffix : "jpg"
/// fullPath : "/path/to/file"

CavityPhoto cavityPhotoFromJson(String str) => CavityPhoto.fromJson(json.decode(str));
String cavityPhotoToJson(CavityPhoto data) => json.encode(data.toJson());
class CavityPhoto {
  CavityPhoto({
      String? docComments, 
      String? documentName, 
      String? downloadType, 
      int? fileSize, 
      String? fileSuffix, 
      String? fullPath,}){
    _docComments = docComments;
    _documentName = documentName;
    _downloadType = downloadType;
    _fileSize = fileSize;
    _fileSuffix = fileSuffix;
    _fullPath = fullPath;
}

  CavityPhoto.fromJson(dynamic json) {
    _docComments = json['docComments'];
    _documentName = json['documentName'];
    _downloadType = json['downloadType'];
    _fileSize = json['fileSize'];
    _fileSuffix = json['fileSuffix'];
    _fullPath = json['fullPath'];
  }
  String? _docComments;
  String? _documentName;
  String? _downloadType;
  int? _fileSize;
  String? _fileSuffix;
  String? _fullPath;
CavityPhoto copyWith({  String? docComments,
  String? documentName,
  String? downloadType,
  int? fileSize,
  String? fileSuffix,
  String? fullPath,
}) => CavityPhoto(  docComments: docComments ?? _docComments,
  documentName: documentName ?? _documentName,
  downloadType: downloadType ?? _downloadType,
  fileSize: fileSize ?? _fileSize,
  fileSuffix: fileSuffix ?? _fileSuffix,
  fullPath: fullPath ?? _fullPath,
);
  String? get docComments => _docComments;
  String? get documentName => _documentName;
  String? get downloadType => _downloadType;
  int? get fileSize => _fileSize;
  String? get fileSuffix => _fileSuffix;
  String? get fullPath => _fullPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['docComments'] = _docComments;
    map['documentName'] = _documentName;
    map['downloadType'] = _downloadType;
    map['fileSize'] = _fileSize;
    map['fileSuffix'] = _fileSuffix;
    map['fullPath'] = _fullPath;
    return map;
  }

}