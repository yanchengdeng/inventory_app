///资产盘点api

import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:inventory_app/app/values/constants.dart';
import '../entity/InventoryData.dart';
import '../utils/http.dart';
import '../widgets/toast.dart';

class InventoryApi<T> {
  //获取未完成资产盘点列表
  static Future<InventoryData> getInventoryData<T>() async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'inventoryTask_list';
    Options options = Options();
    options.headers = fileTokenMaps;

    var response =
        await HttpUtil().get('/inventoryTask/list', options: options);
    return InventoryData.fromJson(response);
  }

  //获取已完成资产盘点列表
  static Future<InventoryData> getInventoryFinishedList<T>(int page) async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'inventoryTask_finishedList';
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
        .post('/inventoryTask/finishedList', data: data, options: options);
    return InventoryData.fromJson(response);
  }

  /**
   * message返回-1和-2需要做APP端做特殊处理。-
   * 1：模具所在的盘点单是否需要盘点，如果不需要此供应商盘点，列表页也不再加载此盘点单，从缓存中删除
   * ，并提示：xxxx（盘点编号）已从任务中移除模具所在的盘点单是否已经取消，
   * -2：如果盘点状态为已取消，列表页也不再加载此盘点单，从缓存中删除，
   * 提示：xxxx（盘点编号）已从任务中移除。其中xxxx，需要把盘点列表的inventoryTaskId一路带到上传界面，以支持此场景
   */
  ///标签类型类型绑定上传
  static Future<int> uploadInventoryTask<T>(String bodyParams) async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'inventoryTask_upload';
    Options options = Options();
    options.headers = fileTokenMaps;

    var response = await HttpUtil()
        .post('/inventoryTask/upload', data: bodyParams, options: options);
    if (response['state'] == API_RESPONSE_OK) {
      toastInfo(msg: '已完成上传');
      return API_RESPONSE_OK;
    } else {
      if (response['message'] == -1) {
        return -1;
      } else if (response['message'] == -2) {
        return -2;
      } else {
        return 0;
      }
    }
  }
}
