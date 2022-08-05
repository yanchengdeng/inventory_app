///资产盘点api

import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../entity/inventory_list.dart';
import '../utils/http.dart';

class InventoryApi<T> {
  //获取未完成资产盘点列表
  static Future<InventoryList> getInventoryList<T>() async {
    Map<String, dynamic> fileTokenMaps = HashMap();
    fileTokenMaps['x-resource-code'] = 'inventoryTask_list';
    Options options = Options();
    options.headers = fileTokenMaps;

    var response =
        await HttpUtil().get('/inventoryTask/list', options: options);
    return InventoryList.fromJson(response);
  }

  //获取已完成资产盘点列表
  static Future<InventoryList> getInventoryFinishedList<T>(int page) async {
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
      'pageSize': 10
    };

    var response = await HttpUtil()
        .post('/inventoryTask/finishedList', data: data, options: options);
    return InventoryList.fromJson(response);
  }
}
