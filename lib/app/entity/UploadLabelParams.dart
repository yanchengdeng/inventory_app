/// bindLabels : ["XP705_0"]
/// cavityPhoto : {"docComments":"","documentName":"","downloadType":"","fileSize":0,"fileSuffix":"","fullPath":""}
/// labelType : 0
/// lat : 0.0
/// lng : 0.0
/// address : "上海xx"
/// nameplatePhoto : {"docComments":"","documentName":"xxx铭牌图","downloadType":"url","fileSize":0,"fileSuffix":"","fullPath":"2022-8-9/testimage_0VcOfkAl2wP.jpg"}
/// overallPhoto : {"docComments":"","documentName":"","downloadType":"","fileSize":0,"fileSuffix":"","fullPath":""}

///上传标签参数
class UploadLabelParams {
  UploadLabelParams({
    List<String>? bindLabels,
    PhotoInfo? cavityPhoto,
    int? labelType,
    double? lat,
    double? lng,
    String? address,
    PhotoInfo? nameplatePhoto,
    PhotoInfo? overallPhoto,
  }) {
    _bindLabels = bindLabels;
    _cavityPhoto = cavityPhoto;
    _labelType = labelType;
    _lat = lat;
    _lng = lng;
    _address = address;
    _nameplatePhoto = nameplatePhoto;
    _overallPhoto = overallPhoto;
  }

  UploadLabelParams.fromJson(dynamic json) {
    _bindLabels =
        json['bindLabels'] != null ? json['bindLabels'].cast<String>() : [];
    _cavityPhoto = json['cavityPhoto'] != null
        ? PhotoInfo.fromJson(json['cavityPhoto'])
        : null;
    _labelType = json['labelType'];
    _lat = json['lat'];
    _lng = json['lng'];
    _address = json['address'];
    _nameplatePhoto = json['nameplatePhoto'] != null
        ? PhotoInfo.fromJson(json['nameplatePhoto'])
        : null;
    _overallPhoto = json['overallPhoto'] != null
        ? PhotoInfo.fromJson(json['overallPhoto'])
        : null;
  }

  List<String>? _bindLabels;
  PhotoInfo? _cavityPhoto;
  int? _labelType;
  double? _lat;
  double? _lng;
  String? _address;
  PhotoInfo? _nameplatePhoto;
  PhotoInfo? _overallPhoto;

  UploadLabelParams copyWith({
    List<String>? bindLabels,
    PhotoInfo? cavityPhoto,
    int? labelType,
    double? lat,
    double? lng,
    String? address,
    PhotoInfo? nameplatePhoto,
    PhotoInfo? overallPhoto,
  }) =>
      UploadLabelParams(
        bindLabels: bindLabels ?? _bindLabels,
        cavityPhoto: cavityPhoto ?? _cavityPhoto,
        labelType: labelType ?? _labelType,
        lat: lat ?? _lat,
        lng: lng ?? _lng,
        address: address ?? _address,
        nameplatePhoto: nameplatePhoto ?? _nameplatePhoto,
        overallPhoto: overallPhoto ?? _overallPhoto,
      );

  List<String>? get bindLabels => _bindLabels;

  PhotoInfo? get cavityPhoto => _cavityPhoto;

  int? get labelType => _labelType;

  double? get lat => _lat;

  double? get lng => _lng;

  String? get address => _address;

  PhotoInfo? get nameplatePhoto => _nameplatePhoto;

  PhotoInfo? get overallPhoto => _overallPhoto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bindLabels'] = _bindLabels;
    if (_cavityPhoto != null) {
      map['cavityPhoto'] = _cavityPhoto?.toJson();
    }
    map['labelType'] = _labelType;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['address'] = _address;
    if (_nameplatePhoto != null) {
      map['nameplatePhoto'] = _nameplatePhoto?.toJson();
    }
    if (_overallPhoto != null) {
      map['overallPhoto'] = _overallPhoto?.toJson();
    }
    return map;
  }
}

/// docComments : ""
/// documentName : ""
/// downloadType : ""
/// fileSize : 0
/// fileSuffix : ""
/// fullPath : ""

class PhotoInfo {
  PhotoInfo({
    String? docComments,
    String? documentName,
    String? downloadType,
    int? fileSize,
    int? photoType,
    String? fileSuffix,
    String? fullPath,

  }) {
    _docComments = docComments;
    _documentName = documentName;
    _downloadType = downloadType;
    _fileSize = fileSize;
    _photoType = photoType;
    _fileSuffix = fileSuffix;
    _fullPath = fullPath;
  }

  PhotoInfo.fromJson(dynamic json) {
    _docComments = json['docComments'];
    _documentName = json['documentName'];
    _downloadType = json['downloadType'];
    _fileSize = json['fileSize'];
    _photoType = json['photoType'];
    _fileSuffix = json['fileSuffix'];
    _fullPath = json['fullPath'];
  }

  String? _docComments;
  String? _documentName;
  String? _downloadType;
  int? _fileSize;
  int? _photoType;
  String? _fileSuffix;
  String? _fullPath;

  PhotoInfo copyWith({
    String? docComments,
    String? documentName,
    String? downloadType,
    int? fileSize,
    int? photoType,
    String? fileSuffix,
    String? fullPath,
  }) =>
      PhotoInfo(
        docComments: docComments ?? _docComments,
        documentName: documentName ?? _documentName,
        downloadType: downloadType ?? _downloadType,
        fileSize: fileSize ?? _fileSize,
        photoType: photoType ??_photoType,
        fileSuffix: fileSuffix ?? _fileSuffix,
        fullPath: fullPath ?? _fullPath,
      );

  String? get docComments => _docComments;

  String? get documentName => _documentName;

  String? get downloadType => _downloadType;

  int? get fileSize => _fileSize;
  int? get photoType => _photoType;

  String? get fileSuffix => _fileSuffix;

  String? get fullPath => _fullPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['docComments'] = _docComments;
    map['documentName'] = _documentName;
    map['downloadType'] = _downloadType;
    map['fileSize'] = _fileSize;
    map['photoType'] = _photoType;
    map['fileSuffix'] = _fileSuffix;
    map['fullPath'] = _fullPath;
    return map;
  }
}
