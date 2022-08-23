/// address : "福建省福州市闽侯县滨城大道阳光城西海岸-B区"
/// lat : 26.13362396
/// lng : 119.15386328

class LocationInfo {
  LocationInfo({
    String? address,
    double? lat,
    double? lng,
  }) {
    _address = address;
    _lat = lat;
    _lng = lng;
  }

  LocationInfo.fromJson(dynamic json) {
    _address = json['address'];
    _lat = json['lat'];
    _lng = json['lng'];
  }
  String? _address;
  double? _lat;
  double? _lng;
  LocationInfo copyWith({
    String? address,
    double? lat,
    double? lng,
  }) =>
      LocationInfo(
        address: address ?? _address,
        lat: lat ?? _lat,
        lng: lng ?? _lng,
      );
  String? get address => _address;
  double? get lat => _lat;
  double? get lng => _lng;
  set lat(double? lat) => _lat = lat;
  set lng(double? lng) => _lng = lng;
  set address(String? address) => _address = address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}
