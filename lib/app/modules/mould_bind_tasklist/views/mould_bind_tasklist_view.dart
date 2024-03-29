import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/MouldBindTask.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/widgets/empty.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../style/text_style.dart';
import '../../../utils/common.dart';
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
    controller.getMouldTaskItems();
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
                              text: '未完成(${controller.mouldTaskItems.length})',
                              selected: homeController.state.selectedMouldTab,
                              isLeft: true,
                              callback: () {
                                ///已选中了 点击无效
                                if (!homeController.state.selectedMouldTab) {
                                  homeController.state.selectedMouldTab =
                                      !homeController.state.selectedMouldTab;
                                }
                              }),
                          flex: 1,
                        ),
                        Expanded(
                          child: selectTabView(
                              text: '已完成',
                              selected: !homeController.state.selectedMouldTab,
                              isLeft: false,
                              callback: () {
                                if (homeController.state.selectedMouldTab) {
                                  homeController.state.selectedMouldTab =
                                      !homeController.state.selectedMouldTab;
                                }
                                if (homeController.mouldTaskFinishedList ==
                                        null ||
                                    homeController
                                            .mouldTaskFinishedList.length ==
                                        0) {
                                  homeController.getMouldTaskFinishedList(
                                      homeController
                                          .state.mouldTaskFinishedPage);
                                }
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
                          enablePullUp: homeController.state.selectedMouldTab
                              ? false
                              : true,
                          scrollDirection: Axis.vertical,
                          //接口无分页 禁止上拉加载更多
                          onRefresh: _onRefresh,
                          onLoading: _onLoadMore,
                          child: homeController.state.selectedMouldTab
                              ? controller.mouldTaskItems.length == 0
                                  ? DefaultEmptyWidget()
                                  : ListView.builder(
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
                                                        '${controller.mouldTaskItems[index].taskType == MOULD_TASK_TYPE_PAY ? '支付任务编号' : '标签替换任务编号'}：'
                                                        '${controller.mouldTaskItems[index].taskNo}',
                                                        style:
                                                            textBoldListTextStyle()),
                                                    Visibility(
                                                      visible: controller
                                                              .mouldTaskItems[
                                                                  index]
                                                              .taskType ==
                                                          MOULD_TASK_TYPE_PAY,
                                                      child: Text(
                                                          'PO编号：${controller.mouldTaskItems[index].poNo}',
                                                          style:
                                                              textNormalListTextStyle()),
                                                    ),
                                                    Text(
                                                        '工装模具总数：${controller.mouldTaskItems[index].mouldList?.length}',
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
                                                                    status:
                                                                        '待绑定',
                                                                    count: controller
                                                                            .mouldTaskItems[
                                                                                index]
                                                                            .mouldList
                                                                            ?.where((element) =>
                                                                                element.bindStatus ==
                                                                                BIND_STATUS_WAITING_BIND)
                                                                            .toList()
                                                                            .length ??
                                                                        0,
                                                                    callback:
                                                                        () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .MOULD_BIND_MOULDLIST,
                                                                          arguments: {
                                                                            'taskType':
                                                                                controller.mouldTaskItems[index].taskType,
                                                                            'taskNo':
                                                                                '${controller.mouldTaskItems[index].taskNo}',
                                                                            'bindStatus':
                                                                                [
                                                                              BIND_STATUS_WAITING_BIND
                                                                            ],
                                                                            "isFinish":
                                                                                false
                                                                          });
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
                                                                    status:
                                                                        '重新绑定',
                                                                    count: controller
                                                                            .mouldTaskItems[
                                                                                index]
                                                                            .mouldList
                                                                            ?.where((element) =>
                                                                                element.bindStatus ==
                                                                                BIND_STATUS_REBIND)
                                                                            .toList()
                                                                            .length ??
                                                                        0,
                                                                    callback:
                                                                        () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .MOULD_BIND_MOULDLIST,
                                                                          arguments: {
                                                                            'taskType':
                                                                                controller.mouldTaskItems[index].taskType,
                                                                            'taskNo':
                                                                                '${controller.mouldTaskItems[index].taskNo}',
                                                                            'bindStatus':
                                                                                [
                                                                              BIND_STATUS_REBIND
                                                                            ],
                                                                            "isFinish":
                                                                                false
                                                                          });
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
                                                                    status:
                                                                        '待上传',
                                                                    count: controller
                                                                            .mouldTaskItems[
                                                                                index]
                                                                            .mouldList
                                                                            ?.where((element) =>
                                                                                element.bindStatus ==
                                                                                BIND_STATUS_WAITING_UPLOAD)
                                                                            .toList()
                                                                            .length ??
                                                                        0,
                                                                    callback:
                                                                        () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .MOULD_BIND_MOULDLIST,
                                                                          arguments: {
                                                                            'taskType':
                                                                                controller.mouldTaskItems[index].taskType,
                                                                            'taskNo':
                                                                                '${controller.mouldTaskItems[index].taskNo}',
                                                                            'bindStatus':
                                                                                [
                                                                              BIND_STATUS_WAITING_UPLOAD
                                                                            ],
                                                                            "isFinish":
                                                                                false
                                                                          });
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
                                                                    status:
                                                                        '已上传',
                                                                    count: controller
                                                                            .mouldTaskItems[
                                                                                index]
                                                                            .mouldList
                                                                            ?.where((element) =>
                                                                                element.bindStatus ==
                                                                                BIND_STATUS_UPLOADED)
                                                                            .toList()
                                                                            .length ??
                                                                        0,
                                                                    callback:
                                                                        () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .MOULD_BIND_MOULDLIST,
                                                                          arguments: {
                                                                            'taskType':
                                                                                controller.mouldTaskItems[index].taskType,
                                                                            'taskNo':
                                                                                '${controller.mouldTaskItems[index].taskNo}',
                                                                            'bindStatus':
                                                                                [
                                                                              BIND_STATUS_UPLOADED
                                                                            ],
                                                                            "isFinish":
                                                                                false
                                                                          });
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
                                                      'taskType': controller
                                                          .mouldTaskItems[index]
                                                          .taskType,
                                                      'taskNo':
                                                          '${controller.mouldTaskItems[index].taskNo}',
                                                      'bindStatus': [
                                                        BIND_STATUS_WAITING_BIND,
                                                        BIND_STATUS_REBIND,
                                                        BIND_STATUS_WAITING_UPLOAD,
                                                        BIND_STATUS_UPLOADED
                                                      ],
                                                      "isFinish": false
                                                    })
                                              },
                                            ),
                                          )),
                                      itemCount: homeController
                                          .mouldBindList.value.data?.length,
                                    )

                              ///已完成 直接数据传递过去
                              : homeController.mouldTaskFinishedList?.length ==
                                      0
                                  ? DefaultEmptyWidget()
                                  : ListView.builder(
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
                                                        '${homeController.mouldTaskFinishedList?[index]?.taskType == MOULD_TASK_TYPE_PAY ? '支付任务编号' : '标签替换任务编号'}：'
                                                        '${homeController.mouldTaskFinishedList?[index]?.taskNo}',
                                                        style:
                                                            textBoldListTextStyle()),
                                                    Visibility(
                                                      visible: homeController
                                                              .mouldTaskFinishedList?[
                                                                  index]
                                                              ?.taskType ==
                                                          MOULD_TASK_TYPE_PAY,
                                                      child: Text(
                                                          'PO编号：${homeController.mouldTaskFinishedList?[index]?.poNo}',
                                                          style:
                                                              textNormalListTextStyle()),
                                                    ),
                                                    Text(
                                                        '工装模具总数：${homeController.mouldTaskFinishedList?[index]?.totalMoulds}',
                                                        style:
                                                            textNormalListTextStyle()),
                                                  ]),
                                            ),
                                            onTap: () => {
                                              /// 已上传的
                                              Get.toNamed(
                                                  Routes.MOULD_BIND_MOULDLIST,
                                                  arguments: {
                                                    'taskType': homeController
                                                        .mouldTaskFinishedList[
                                                            index]
                                                        ?.taskType,
                                                    'taskNo':
                                                        '${homeController.mouldTaskFinishedList[index]?.taskNo}',
                                                    'bindStatus': [
                                                      BIND_STATUS_WAITING_BIND,
                                                      BIND_STATUS_REBIND,
                                                      BIND_STATUS_WAITING_UPLOAD,
                                                      BIND_STATUS_UPLOADED
                                                    ],
                                                    "isFinish": true
                                                  })
                                            },
                                          ))),
                                      itemCount: homeController
                                          .mouldTaskFinishedList.length,
                                    )))
                ],
              ),
            )));
  }

  Future<void> _onRefresh() async {
    if (homeController.state.selectedMouldTab) {
      await homeController.getMouldTaskList();
      controller.getMouldTaskItems();
      if (await CommonUtils.isConnectNet()) {
        toastInfo(msg: "最新任务已更新");
      }
    } else {
      homeController.state.mouldTaskFinishedPage = 0;
      await homeController
          .getMouldTaskFinishedList(homeController.state.mouldTaskFinishedPage);
    }
    _refreshBindTaskController.refreshCompleted();
    _refreshBindTaskController.loadComplete();
  }

  Future<void> _onLoadMore() async {
    homeController.state.mouldTaskFinishedPage++;
    MouldBindTask mouldBindList = await homeController
        .getMouldTaskFinishedList(homeController.state.mouldTaskFinishedPage);

    if (mouldBindList.data != null && mouldBindList.data?.length == PAGE_SIZE) {
      _refreshBindTaskController.loadComplete();
    } else {
      _refreshBindTaskController.loadNoData();
    }
  }
}
