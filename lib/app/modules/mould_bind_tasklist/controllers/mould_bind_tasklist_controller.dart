import 'package:get/get.dart';
import 'package:inventory_app/app/utils/logger.dart';

/**
 * 模具绑定控制器  主要处理业务逻辑
 */
class MouldBindTaskListController extends GetxController {


  @override
  void onInit() {
    super.onInit();
    Log.d("MouldBindTasklistController--onInit()");
  }

  @override
  void onReady() {
    super.onReady();
    Log.d("MouldBindTasklistController--onReady()");
  }

  @override
  void onClose() {
    Log.d("MouldBindTasklistController--onClose()");
  }
}
