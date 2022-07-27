import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:inventory_app/app/services/services.dart';

import '../entity/base_data.dart';
import '../utils/http.dart';
import '../values/server.dart';
import '../values/storage.dart';

///文件api 处理
class FileApi<T> {
  ///获取文件服务token
  static Future<FileTokenResponseEntity> getFileToken<T>() async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'file_token_get';
    Options options = Options();
    options.headers = fileTokenMaps;
    var response = await HttpUtil().get(
      '${SERVER_FILE_API_URL}/file/token/get',
      options: options,
    );
    FileTokenResponseEntity fileTokenResponseEntity =
        FileTokenResponseEntity.fromJson(response);
    if (fileTokenResponseEntity.data != null) {
      //保存文件服务token
      StorageService.to
          .setString(STORAGE_FILE_TOKEN, fileTokenResponseEntity.data!);
    }
    return fileTokenResponseEntity;
  }

  ///获取文件服务token
  static Future<FileTokenResponseEntity> uploadFile<T>() async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'file_backend_upload';
    Options options = Options();
    options.headers = fileTokenMaps;

    var formData = {
      'token': StorageService.to.getString(STORAGE_FILE_TOKEN),
      "file": await MultipartFile.fromFile(
          '/data/user/0/com.luojie.erapp.inventory_app/cache/CAP518496658039260943.jpg',
          filename: 'CAP518496658039260943.jpg')
    };

    var response = await HttpUtil().postForm(
        '${SERVER_FILE_UPLOAD}/file/frontend/upload',
        options: options,
        data: formData);
    FileTokenResponseEntity fileTokenResponseEntity =
        FileTokenResponseEntity.fromJson(response);

    return fileTokenResponseEntity;
  }
}
