import 'dart:collection';

import 'package:dio/dio.dart';

import '../entity/mould_bind.dart';
import '../utils/utils.dart';

/**
 *
 * 模具任务api
 *
 * */
class MouldTaskApi<T> {
  //获取模具任务列表
  static Future<MouldBindList> getMouldTaskList<T>(
      Map<String, dynamic> params) async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'mouldBindTask_list';
    Options options = Options();
    options.headers = fileTokenMaps;

    var response = await HttpUtil()
        .get('/mouldBindTask/list', queryParameters: params, options: options);
    return MouldBindList.fromJson(response);
  }
}
