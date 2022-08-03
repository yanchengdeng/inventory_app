import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as get_multipart_file;

///MultiPartFile 存在于  get  和dio 两个木块 此种方法避免
import 'package:get/get_core/src/get_main.dart';
import 'package:inventory_app/app/services/services.dart';
import 'package:inventory_app/app/utils/logger.dart';
import '../entity/base_data.dart';
import '../entity/cache_data.dart';
import '../modules/mould_read_result/controllers/mould_read_result_controller.dart';
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
      '/file/token/get',
      options: options,
    );
    Log.d("文件token：${response}");

    if (response is String) {
      Log.d("文件token类型：字符串");
    } else if (response is Map) {
      Log.d("文件token类型：map");
    }

// var json1 = jsonDecode(response);
//     if (json1 is String) {
//       Log.d("文件json1类型：字符串");
//     } else if (json1 is Map) {
//       Log.d("文件json1类型：map");
//     }

    FileTokenResponseEntity fileTokenResponseEntity =
        FileTokenResponseEntity.fromJson(jsonDecode(response));
    if (fileTokenResponseEntity.data != null) {
      //保存文件服务token
      StorageService.to
          .setString(STORAGE_FILE_TOKEN, fileTokenResponseEntity.data!);
    }
    return fileTokenResponseEntity;
  }

  ///获取文件服务token
  static void uploadFile<T>(String filePath) async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'file_backend_upload';
    Options options = Options();
    options.headers = fileTokenMaps;
    EasyLoading.show(status: "上传中...");

    ///防止文件token失效导致 中途操作中断，每次上传重新获取
    FileTokenResponseEntity fileTokenResponseEntity = await getFileToken();

    String fileName =
        filePath.substring(filePath.lastIndexOf('/') + 1, filePath.length);

    var formData = {
      'token': fileTokenResponseEntity.data,
      "file": await MultipartFile.fromFile(filePath, filename: fileName)
      // 'downloadType':'file_id'
    };

    var response = await HttpUtil().postForm(
        '${SERVER_FILE_UPLOAD}/silkfile/frontend/upload',
        options: options,
        data: formData);

    Log.d("返回的图片URL/uuid=$response");

    EasyLoading.dismiss();
    final MouldReadResultController resultController =
        Get.find<MouldReadResultController>();
    resultController.refreshImage(UploadImageInfo(
        fileName: fileName, filePath: filePath, uriUuid: response.toString()));
    Get.back();
  }
}
