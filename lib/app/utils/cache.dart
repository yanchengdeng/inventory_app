import 'dart:collection';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inventory_app/app/services/services.dart';
import 'package:inventory_app/app/utils/utils.dart';

import '../entity/cache_mould_bind_data.dart';
import '../entity/mould_bind.dart';
import '../values/storage.dart';

/**
 * 缓存跟着账号走  和产品确认账号的来源？？？
 * 本地缓存数据工具
 */

class CacheUtils extends GetxController {
  static CacheUtils get to => Get.find();

  /// todo  假设用户  001
  static const String USER_CODE = '0001';

  ///保存下发的模具绑定任务

  Future<void> saveMouldTask(MouldData data) async {
    var cacheMould = await StorageService.to.getString(STORAGE_TASK_MOULD_DATA);
    // if (cacheMould.isEmpty) {
    List<CacheMouldBindData> list = [
      CacheMouldBindData(userId: USER_CODE, data: data)
    ];

    ///首次保存
    await StorageService.to
        .setString(STORAGE_TASK_MOULD_DATA, json.encode(list));
    // } else {
    ///TODO  对比保存 待确定
    // }
  }

  /// 获取下发的磨具绑定任务
  Future<void> getMouldTask() async {
    var cacheMould = await StorageService.to.getString(STORAGE_TASK_MOULD_DATA);
    if (cacheMould.isNotEmpty) {
      final List<dynamic> cacheMouldBindData = jsonDecode(cacheMould);

      var _InternalLinkedHashMap = cacheMouldBindData
          .where((element) => element['userId'] == USER_CODE)
          .first;



      CacheMouldBindData bindData = CacheMouldBindData.fromJson(_InternalLinkedHashMap);

      Log.d("解析成功：${cacheMouldBindData.length}---${bindData.data?.finished}");
    } else {
      Log.d("未找到数据，请检查网络数据");
    }
  }
}
