import '../entity/mould_bind.dart';
import '../utils/utils.dart';

///模具任务api
class MouldTaskApi<T> {
  static Future<MouldBindList> getMouldTaskList<T>(
      Map<String, dynamic> params) async {
    var response = await HttpUtil().get(
      '/mouldBindTask/list',
      queryParameters: params,
    );
    return MouldBindList.fromJson(response);
  }
}
