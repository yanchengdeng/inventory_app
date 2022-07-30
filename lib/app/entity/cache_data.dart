import 'package:inventory_app/app/entity/inventory_list.dart';
import 'package:inventory_app/app/entity/mould_bind.dart';

/**
 * 本地缓存模具绑定任务数据
 * 存储方式   List(CacheMouldBindData())
 */

class CacheMouldBindData{
  String? userId;
  MouldData? data;

  CacheMouldBindData({ this.userId,  this.data});

  CacheMouldBindData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    data = json['data'] != null ? new MouldData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}


/**
 * 本地缓存资产盘点任务数据
 * 存储方式   List(CacheInventoryData())
 */

class CacheInventoryData{
  String? userId;
  InventroyData? data;

  CacheInventoryData({ this.userId,  this.data});

  CacheInventoryData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    data = json['data'] != null ? new InventroyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}


///上传图片信息
class UploadImageInfo {
  String? fileName;
  String? filePath;
  String? uriUuid;

  UploadImageInfo({this.fileName, this.filePath, this.uriUuid});

  UploadImageInfo.fromJson(Map<String, dynamic> json) {
    this.fileName = json["fileName"];
    this.filePath = json["filePath"];
    this.uriUuid = json["UriUUID"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["fileName"] = this.fileName;
    data["filePath"] = this.filePath;
    data["UriUUID"] = this.uriUuid;
    return data;
  }
}



