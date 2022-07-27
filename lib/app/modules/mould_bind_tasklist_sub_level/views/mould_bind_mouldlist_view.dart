import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../style/text_style.dart';
import '../../../utils/cache.dart';
import '../../../values/constants.dart';
import '../controllers/mould_bind_mouldlist_controller.dart';

///  模具绑定任务信息列表
class MouldBindMouldListView extends GetView<MouldBindMouldlistController> {
  final RefreshController _refreshBindTaskController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    var taskNo = Get.arguments['taskNo'];
    var taskType = Get.arguments['taskType'];
    var bindStatus = Get.arguments['bindStatus'];

    CacheUtils.to.getMouldTaskListByKeyOrStatus(taskNo, '', [bindStatus], []);
    //
    // Log.d(
    //     "传入二级模具菜单参数111111：taskNo = $taskNo,taskType = ${taskType},bindStatus = ${bindStatus}");

    return Scaffold(
        appBar: AppBar(
          title: Text('模具绑定'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: inputTextEdit(
                      hintText: '搜资产编号、名称',
                      inputOnSubmit: (value) {
                        CacheUtils.to.mouldSearchKey = value;
                        CacheUtils.to.getMouldTaskListByKeyOrStatus(
                            Get.arguments['taskNo'], '', [-1], []);
                      })),
              Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Text('全部'),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text('工装类型'),
                      flex: 1,
                    )
                  ],
                ),
              ),

              ///https://github.com/peng8350/flutter_pulltorefresh/issues/572  这里需要加入Expanded 避免该issue
              Obx(() => Container(
                      child: Expanded(
                    child: SmartRefresher(
                        controller: _refreshBindTaskController,
                        enablePullDown: true,
                        enablePullUp: false,
                        scrollDirection: Axis.vertical,
                        //接口无分页 禁止上拉加载更多
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          itemBuilder: ((context, index) => Card(
                                elevation: CARD_ELEVATION,
                                shadowColor: Colors.grey,
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getTextByStatus(CacheUtils
                                                  .to
                                                  .mouldBindTaskListSearch
                                                  ?.mouldList[index]
                                                  ?.bindStatus),
                                              Text(
                                                  '${CacheUtils.to.mouldBindTaskListSearch?.mouldList[index]?.assetNo}',
                                                  style:
                                                      textNormalListTextStyle())
                                            ],
                                          ),
                                          Spacer(flex: 1),
                                          Obx(
                                            () => Visibility(
                                              visible: CacheUtils
                                                      .to
                                                      .mouldBindTaskListSearch
                                                      ?.mouldList[index]
                                                      ?.bindStatus !=
                                                  BIND_STATUS_UPLOADED,
                                              child: ElevatedButton(
                                                  onPressed: () => {
                                                        ///其他状态直接打开编辑上传页
                                                        Get.toNamed(
                                                            Routes
                                                                .MOULD_READ_RESULT,
                                                            arguments: {
                                                              "taskType": Get
                                                                      .arguments[
                                                                  'taskType'],
                                                              "taskNo":
                                                                  Get.arguments[
                                                                      'taskNo'],
                                                              "assetNo": CacheUtils
                                                                  .to
                                                                  .mouldBindTaskListSearch
                                                                  ?.mouldList[
                                                                      index]
                                                                  .assetNo
                                                            })
                                                      },
                                                  child: Text('绑定')),
                                            ),
                                          ),
                                        ]),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0,
                                              top: 8,
                                              right: 0,
                                              bottom: 8),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                            '标签编号:${CacheUtils.to.mouldBindTaskListSearch?.mouldList[index]?.bindStatusText}',
                                            style: textNormalListTextStyle()),
                                        Text(
                                            '零件号:${CacheUtils.to.mouldBindTaskListSearch?.mouldList[index]?.moldNo}',
                                            style: textNormalListTextStyle()),
                                        Text(
                                            '零件名称：${CacheUtils.to.mouldBindTaskListSearch?.mouldList[index]?.moldName}',
                                            style: textNormalListTextStyle()),
                                        Text(
                                            'SGM车型:${CacheUtils.to.mouldBindTaskListSearch?.mouldList[index]?.toolingName}',
                                            style: textNormalListTextStyle()),
                                        Text(
                                            '备注：${CacheUtils.to.mouldBindTaskListSearch?.mouldList[index]?.remark}',
                                            style: textNormalListTextStyle())
                                      ],
                                    ),
                                  ),
                                  onTap: () => {
                                    if (CacheUtils.to.mouldBindTaskListSearch
                                            ?.mouldList[index]?.bindStatus ==
                                        BIND_STATUS_UPLOADED)
                                      {
                                        ///已上传
                                        ///

                                        Get.toNamed(
                                            Routes.MOULD_RESULT_ONLY_VIEW,
                                            arguments: {
                                              "taskType":
                                                  Get.arguments['taskType'],
                                              "taskNo": Get.arguments['taskNo'],
                                              "assetNo": CacheUtils
                                                  .to
                                                  .mouldBindTaskListSearch
                                                  ?.mouldList[index]
                                                  .assetNo
                                            })
                                      }
                                    else
                                      {
                                        ///其他状态直接打开编辑上传页
                                        Get.toNamed(Routes.MOULD_READ_RESULT,
                                            arguments: {
                                              "taskType":
                                                  Get.arguments['taskType'],
                                              "taskNo": Get.arguments['taskNo'],
                                              "assetNo": CacheUtils
                                                  .to
                                                  .mouldBindTaskListSearch
                                                  ?.mouldList[index]
                                                  .assetNo
                                            })
                                      }
                                  },
                                ),
                              )),
                          itemCount: CacheUtils
                              .to.mouldBindTaskListSearch.mouldList.length,
                        )),
                  )))
            ],
          ),
        ));
  }

  Future<void> _onRefresh() async {
    _refreshBindTaskController.refreshCompleted();
  }

  /// 根据绑定状态输入不同颜色
  getTextByStatus(int status) {
    var style = textLitleBlackTextStyle();
    if (status == BIND_STATUS_WAING) {
      style = textLitleOrangeTextStyle();
    } else if (status == BIND_STATUS_REBIND) {
      style = textLitleRedTextStyle();
    } else if (status == BIND_STATUS_UPLOADED) {
      style = textLitleBlackTextStyle();
    } else if (status == BIND_STATUS_WAITING_UPLOAD) {
      style = textLitleGreenTextStyle();
    }

    return Text('${MOULD_BIND_STATUS[status]}', style: style);
  }
}
