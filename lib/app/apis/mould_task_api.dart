import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../entity/MouldBindTask.dart';
import '../utils/utils.dart';
import '../values/constants.dart';

/**
 *
 * 模具任务api
 *
 * */
class MouldTaskApi<T> {
  ///获取未完成模具任务列表
  static Future<MouldBindTask> getMouldTaskList<T>() async {
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

    return MouldBindTask.fromJson(response);
  }

  ///获取已完成资产盘点列表
  static Future<MouldBindTask> getMouldBindListFinishedList<T>(int page) async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'mouldBindTask_finishedList';
    Options options = Options();
    options.headers = fileTokenMaps;

    ///"orderField": "",
    // 	"orderType": "",
    // 	"pageNum": 0,
    // 	"pageSize": 5
    var data = {
      'orderField': "",
      'orderType': '',
      'pageNum': page,
      'pageSize': PAGE_SIZE
    };

    var response = await HttpUtil()
        .post('/mouldBindTask/finishedList', data: data, options: options);
    return MouldBindTask.fromJson(response);
  }

  //支付类型绑定上传
  static Future<bool> uploadForPayType<T>(
      int assetBindTaskId, String bodyParams) async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'mould_assetBindUpload';
    Options options = Options();
    options.headers = fileTokenMaps;

    // var data = {
    //   'assetBindTaskId': assetBindTaskId,
    //   'bodyParams': bodyParams,
    // };

    var response = await HttpUtil().post(
        '/mould/assetBindUpload/${assetBindTaskId}',
        data: bodyParams,
        options: options);
    if (response['state'] == API_RESPONSE_OK) {
      toastInfo(msg: '已完成上传');
    } else {
      toastInfo(msg: response['message']);
    }
    return response['state'] == API_RESPONSE_OK;
  }

  ///标签类型类型绑定上传
  static Future<bool> uploadForLableReplaceType<T>(
      int labelReplaceTaskId, String bodyParams) async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'mould_labelReplaceBindUpload';
    Options options = Options();
    options.headers = fileTokenMaps;

    var response = await HttpUtil().post(
        '/mould/labelReplaceBindUpload/${labelReplaceTaskId}',
        data: bodyParams,
        options: options);
    if (response['state'] == API_RESPONSE_OK) {
      toastInfo(msg: '已完成上传');
    } else {
      toastInfo(msg: response['message']);
    }
    return response['state'] == API_RESPONSE_OK;
  }
}
