import 'dart:collection';
import 'package:dio/dio.dart';
import '../entity/base_data.dart';
import '../utils/http.dart';
import '../values/server.dart';

///文件api 处理
class FileApi<T> {
  ///获取文件服务token
  static Future<BaseResponseEntity> getFileToken<T>() async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'file_token_get';
    fileTokenMaps['x-track-code'] = DateTime.now().microsecondsSinceEpoch;
    Options options = Options();
    options.headers = fileTokenMaps;
    var response = await HttpUtil().get(
      '${SERVER_FILE_API_URL}/file/token/get',
      options: options,
    );
    return BaseResponseEntity.fromJson(response);
  }
}
