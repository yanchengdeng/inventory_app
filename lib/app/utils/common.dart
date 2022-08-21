import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/logger.dart';
import '../routes/app_pages.dart';
import '../services/storage.dart';
import '../store/user.dart';
import '../style/color.dart';
import '../values/values.dart';
import 'package:connectivity/connectivity.dart';

/**
 * 常见工具类
 */

class CommonUtils {
  //退出登录
  static void logOut() {
    UserStore.to.onLogout();
    Get.offAllNamed(Routes.SPLASH);
    EasyLoading.showError('请重新登录');
  }

  /**
   * 通用型对话框
   */
  static void showCommonDialog(
      {String? title,
      required String content,
      required VoidCallback? callback}) {
    Get.defaultDialog(
      title: "温馨提示",
      content: Container(
          margin: EdgeInsetsDirectional.only(start: 10, end: 10),
          child: Text('$content')),
      confirm: ElevatedButton(
        onPressed: callback,
        child: Text(
          '确定',
          style: TextStyle(color: AppColor.accentColor),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            elevation: MaterialStateProperty.all(0)),
      ),
      cancel: ElevatedButton(
        onPressed: () => {Get.back()},
        child: Text(
          '取消',
          style: TextStyle(color: Colors.black45),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            elevation: MaterialStateProperty.all(0)),
      ),
    );
  }

  ///获取网络图片展示地址
  static String getNetImageUrl(String uriUuid) {
    String imageUrl = SERVER_FILE_UPLOAD +
        "/file/frontend/" +
        Uri.encodeComponent(uriUuid) +
        '?token=' +
        StorageService.to.getString(STORAGE_FILE_TOKEN) +
        "&mediaType=image";
    Log.d("加载图片：${imageUrl}");
    return imageUrl;
  }

  static Future<bool> isConnectNet() async {
    var connectResult = await (Connectivity().checkConnectivity());
    return connectResult != ConnectivityResult.none;
  }
}
