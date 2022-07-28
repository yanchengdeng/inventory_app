import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../style/text_style.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import '../../../values/constants.dart';
import '../controllers/mould_bind_tasklist_controller.dart';

/**
 * 绑定任务列表
 */
class MouldBindTaskListView extends GetView<MouldBindTaskListController> {
  final RefreshController _refreshBindTaskController =
      RefreshController(initialRefresh: false);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('模具绑定'),
          centerTitle: true,
        ),
        body: Obx(() => Container(
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: selectTabView(
                              text:
                                  '未完成(${CacheUtils.to.mouldBindTaskList?.unfinished})',
                              selected: homeController.state.selectedTab,
                              isLeft: true,
                              callback: () {
                                homeController.state.selectedTab =
                                    !homeController.state.selectedTab;
                              }),
                          flex: 1,
                        ),
                        Expanded(
                          child: selectTabView(
                              text:
                                  '已完成(${CacheUtils.to.mouldBindTaskList?.finished})',
                              selected: !homeController.state.selectedTab,
                              isLeft: false,
                              callback: () {
                                homeController.state.selectedTab =
                                    !homeController.state.selectedTab;
                              }),
                          flex: 1,
                        )
                      ],
                    ),
                  ),

                  ///https://github.com/peng8350/flutter_pulltorefresh/issues/572  这里需要加入Expanded 避免该issue
                  Expanded(
                      child: SmartRefresher(
                          controller: _refreshBindTaskController,
                          enablePullDown: true,
                          enablePullUp: false,
                          scrollDirection: Axis.vertical,
                          //接口无分页 禁止上拉加载更多
                          onRefresh: _onRefresh,
                          child: homeController.state.selectedTab
                              ? ListView.builder(
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
                                                Text(
                                                    '${CacheUtils.to.mouldBindTaskList?.unfinishedTaskList?[index]?.taskType == MOULD_TASK_TYPE_PAY ? '支付任务编号' : '标签替换任务编号'}：${CacheUtils.to.mouldBindTaskList?.unfinishedTaskList?[index]?.taskNo}',
                                                    style:
                                                        textBoldListTextStyle()),
                                                Text(
                                                    'PO编号：${CacheUtils.to.mouldBindTaskList?.unfinishedTaskList?[index]?.poNo}',
                                                    style:
                                                        textNormalListTextStyle()),
                                                Text(
                                                    '工装模具总数：${CacheUtils.to.mouldBindTaskList?.unfinishedTaskList?[index]?.totalMoulds}',
                                                    style:
                                                        textNormalListTextStyle()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0,
                                                          top: 8,
                                                          right: 0,
                                                          bottom: 8),
                                                  child: Divider(
                                                    color: Colors.grey,
                                                    height: 1,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child:
                                                            buildMouldStatusItem(
                                                                status: '待绑定',
                                                                count: CacheUtils
                                                                    .to
                                                                    .mouldBindTaskListForWaitBind(
                                                                        index,
                                                                        BIND_STATUS_WAING)
                                                                    .length,
                                                                callback: () {
                                                                  toastInfo(
                                                                      msg:
                                                                          "待绑定");
                                                                })),
                                                    SizedBox(
                                                        width: 1,
                                                        height: 35,
                                                        child: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .grey),
                                                        )),
                                                    Expanded(
                                                        child:
                                                            buildMouldStatusItem(
                                                                status: '重新绑定',
                                                                count: CacheUtils
                                                                    .to
                                                                    .mouldBindTaskListForWaitBind(
                                                                        index,
                                                                        BIND_STATUS_REBIND)
                                                                    .length,
                                                                callback: () {
                                                                  toastInfo(
                                                                      msg:
                                                                          "重新绑定");
                                                                })),
                                                    SizedBox(
                                                        width: 1,
                                                        height: 35,
                                                        child: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .grey),
                                                        )),
                                                    Expanded(
                                                        child:
                                                            buildMouldStatusItem(
                                                                status: '待上传',
                                                                count: CacheUtils
                                                                    .to
                                                                    .mouldBindTaskListForWaitBind(
                                                                        index,
                                                                        BIND_STATUS_WAITING_UPLOAD)
                                                                    .length,
                                                                callback: () {
                                                                  toastInfo(
                                                                      msg:
                                                                          "待上传");
                                                                })),
                                                    SizedBox(
                                                        width: 1,
                                                        height: 35,
                                                        child: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .grey),
                                                        )),
                                                    Expanded(
                                                        child:
                                                            buildMouldStatusItem(
                                                                status: '已上传',
                                                                count: CacheUtils
                                                                    .to
                                                                    .mouldBindTaskListForWaitBind(
                                                                        index,
                                                                        BIND_STATUS_UPLOADED)
                                                                    .length,
                                                                callback: () {
                                                                  toastInfo(
                                                                      msg:
                                                                          "已上传");
                                                                }))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () => {
                                            ///  未上传的 ==》绑定
                                            Get.toNamed(
                                                Routes.MOULD_BIND_MOULDLIST,
                                                arguments: {
                                                  'taskType':
                                                      '${CacheUtils.to.mouldBindTaskList?.unfinishedTaskList?[index]?.taskType}',
                                                  'taskNo':
                                                      '${CacheUtils.to.mouldBindTaskList?.unfinishedTaskList?[index]?.taskNo}',
                                                  'bindStatus': BIND_STATUS_ALL,
                                                  "isFinish": false
                                                })
                                          },
                                        ),
                                      )),
                                  itemCount: CacheUtils.to.mouldBindTaskList
                                      ?.unfinishedTaskList?.length,
                                )
                              : ListView.builder(
                                  itemBuilder: ((context, index) => Card(
                                      elevation: 10,
                                      shadowColor: Colors.grey,
                                      child: InkWell(
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${CacheUtils.to.mouldBindTaskList?.finishedTaskList?[index]?.taskType == MOULD_TASK_TYPE_PAY ? '支付任务编号' : '标签替换任务编号'}：${CacheUtils.to.mouldBindTaskList?.finishedTaskList?[index]?.taskNo}',
                                                    style:
                                                        textBoldListTextStyle()),
                                                Text(
                                                    'PO编号：${CacheUtils.to.mouldBindTaskList?.finishedTaskList?[index]?.poNo}',
                                                    style:
                                                        textNormalListTextStyle()),
                                                Text(
                                                    '工装模具总数：${CacheUtils.to.mouldBindTaskList?.finishedTaskList?[index]?.totalMoulds}',
                                                    style:
                                                        textNormalListTextStyle()),
                                              ]),
                                        ),
                                        onTap: () => {
                                          /// 已上传的
                                          Get.toNamed(
                                              Routes.MOULD_BIND_MOULDLIST,
                                              arguments: {
                                                'taskType':
                                                    '${CacheUtils.to.mouldBindTaskList?.finishedTaskList?[index]?.taskType}',
                                                'taskNo':
                                                    '${CacheUtils.to.mouldBindTaskList?.finishedTaskList?[index]?.taskNo}',
                                                'bindStatus': BIND_STATUS_ALL,
                                                "isFinish": true
                                              })
                                        },
                                      ))),
                                  itemCount: CacheUtils.to.mouldBindTaskList
                                      ?.finishedTaskList?.length,
                                )))
                ],
              ),
            )));
  }

  Future<void> _onRefresh() async {
    await homeController.getMouldTaskList();
    _refreshBindTaskController.refreshCompleted();
    toastInfo(msg: "最新任务已更新");
  }
}
