import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../style/text_style.dart';
import '../controllers/mould_bind_tasklist_controller.dart';

/**
 * 模具绑定列表
 */
class MouldBindTaskListView extends GetView<MouldBindTasklistController> {
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
                                  '未完成(${homeController.state.mouldBindTaskList?.data?.unfinished})',
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
                                  '已完成(${homeController.state.mouldBindTaskList?.data?.finished})',
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
                                                    '支付任务编号：${homeController.state.mouldBindTaskList?.data?.unfinishedTaskList?[index]?.taskNo}',
                                                    style:
                                                        textBoldListTextStyle()),
                                                Text(
                                                    'PO编号：${homeController.state.mouldBindTaskList?.data?.unfinishedTaskList?[index]?.poNo}',
                                                    style:
                                                        textNormalListTextStyle()),
                                                Text(
                                                    '工装模具总数：${homeController.state.mouldBindTaskList?.data?.unfinishedTaskList?[index]?.totalMoulds}',
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
                                                                count: 1,
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
                                                                count: 5,
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
                                                                count: 1,
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
                                                                count: 6,
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
                                          onTap: () => {toastInfo(msg: '全局跳转')},
                                        ),
                                      )),
                                  itemCount: homeController
                                      .state
                                      .mouldBindTaskList
                                      ?.data
                                      ?.unfinishedTaskList
                                      ?.length,
                                )
                              : ListView.builder(
                                  itemBuilder: ((context, index) => Card(
                                      elevation: 10,
                                      shadowColor: Colors.grey,
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '支付任务编号：${homeController.state.mouldBindTaskList?.data?.finishedTaskList?[index]?.taskNo}',
                                                  style:
                                                      textBoldListTextStyle()),
                                              Text(
                                                  'PO编号：${homeController.state.mouldBindTaskList?.data?.finishedTaskList?[index]?.poNo}',
                                                  style:
                                                      textNormalListTextStyle()),
                                              Text(
                                                  '工装模具总数：${homeController.state.mouldBindTaskList?.data?.finishedTaskList?[index]?.totalMoulds}',
                                                  style:
                                                      textNormalListTextStyle()),
                                            ]),
                                      ))),
                                  itemCount: homeController
                                      .state
                                      .mouldBindTaskList
                                      ?.data
                                      ?.finishedTaskList
                                      ?.length,
                                )))
                ],
              ),
            )));
  }

  Future<void> _onRefresh() async {
    await homeController.getMouldTaskList();
    _refreshBindTaskController.refreshCompleted();
  }
}
