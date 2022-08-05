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
  static Future<MouldBindList> getMouldTaskList<T>() async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'mouldBindTask_list';
    Options options = Options();
    options.headers = fileTokenMaps;

    var response =
        await HttpUtil().get('/mouldBindTask/list', options: options);

    if (response is String) {
      Log.d("模具列表类型：字符串");
    } else if (response is Map) {
      Log.d("模具列表类型：map");
    }

    return MouldBindList.fromJson(response);
  }
}
