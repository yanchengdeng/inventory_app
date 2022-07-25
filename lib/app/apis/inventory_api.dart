///资产盘点api

import 'dart:collection';

import 'package:dio/dio.dart';

import '../entity/inventory_list.dart';
import '../utils/http.dart';

class InventoryApi<T> {
  //获取资产盘点列表
  static Future<InventoryList> getInventoryList<T>(
      Map<String, dynamic> params) async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'inventoryTask_list';
    Options options = Options();
    options.headers = fileTokenMaps;

    var response = await HttpUtil()
        .get('/inventoryTask/list', queryParameters: params, options: options);
    return InventoryList.fromJson(response);
  }
}
