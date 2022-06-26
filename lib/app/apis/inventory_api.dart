///资产盘点api

import '../entity/inventory_list.dart';
import '../utils/http.dart';

class InventoryApi<T> {
  //获取资产盘点列表
  static Future<InventoryList> getInventoryList<T>(
      Map<String, dynamic> params) async {
    var response = await HttpUtil().get(
      '/inventoryTask/list',
      queryParameters: params,
    );
    return InventoryList.fromJson(response);
  }
}
