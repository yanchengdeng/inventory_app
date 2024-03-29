import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/widgets/empty.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../entity/InventoryData.dart';
import '../../../routes/app_pages.dart';
import '../../../style/text_style.dart';
import '../../../values/constants.dart';
import '../../../widgets/button.dart';
import '../../../widgets/toast.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/inventory_tasklist_controller.dart';

/**
 * 资产盘点列表
 */
class InventoryTaskListView extends GetView<InventoryTasklistController> {
  final RefreshController _refreshBindTaskController =
      RefreshController(initialRefresh: false);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    controller.getInventoryList();
    return Scaffold(
        appBar: AppBar(
          title: Text('资产盘点'),
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
                              text: '未完成(${controller.inventroyList.length})',
                              selected:
                                  homeController.state.selectedInventoryTab,
                              isLeft: true,
                              callback: () {
                                if (!homeController
                                    .state.selectedInventoryTab) {
                                  homeController.state.selectedInventoryTab =
                                      !homeController
                                          .state.selectedInventoryTab;
                                }
                              }),
                          flex: 1,
                        ),
                        Expanded(
                          child: selectTabView(
                              text: '已完成',
                              selected:
                                  !homeController.state.selectedInventoryTab,
                              isLeft: false,
                              callback: () {
                                if (homeController.state.selectedInventoryTab) {
                                  homeController.state.selectedInventoryTab =
                                      !homeController
                                          .state.selectedInventoryTab;

                                  if (homeController.inventoryFinishedList ==
                                          null ||
                                      homeController
                                              .inventoryFinishedList.length ==
                                          0) {
                                    homeController.getInventoryFinishedList(
                                        homeController
                                            .state.inventoryFinishedPage);
                                  }
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
                          enablePullUp:
                              homeController.state.selectedInventoryTab
                                  ? false
                                  : true,
                          scrollDirection: Axis.vertical,
                          //接口无分页 禁止上拉加载更多
                          onRefresh: _onRefresh,
                          onLoading: _onLoadMore,
                          child: homeController.state.selectedInventoryTab
                              ? controller.inventroyList.length == 0
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
                                                        '${controller.inventroyList[index].taskNo}',
                                                        style:
                                                            textBoldNumberStyle()),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topStart,
                                                            child: Text(
                                                                '盘点年份：${controller.inventroyList[index].inventoryYear}',
                                                                style:
                                                                    textNormalListTextStyle()),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topEnd,
                                                            child: Text(
                                                                '盘点类型：${controller.inventroyList[index].inventoryTypeText}',
                                                                style:
                                                                    textNormalListTextStyle()),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topStart,
                                                            child: Text(
                                                                '截止日期：${controller.inventroyList[index].endDate}',
                                                                style:
                                                                    textNormalListTextStyle()),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topEnd,
                                                            child: Text(
                                                                '盘点总数：${controller.inventroyList[index].list?.length}',
                                                                style:
                                                                    textNormalListTextStyle()),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                                                        '未盘点',
                                                                    count: controller
                                                                            .inventroyList[
                                                                                index]
                                                                            .list
                                                                            ?.where((element) =>
                                                                                element.assetInventoryStatus ==
                                                                                INVENTORY_STATUS_NOT)
                                                                            .length ??
                                                                        0,
                                                                    callback:
                                                                        () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .INVENTORY_TASKLIST_SUB_LEVEL,
                                                                          arguments: {
                                                                            'taskNo':
                                                                                '${homeController.inventoryList.value.data?[index].taskNo}',
                                                                            'bindStatus':
                                                                                [
                                                                              INVENTORY_STATUS_NOT
                                                                            ],
                                                                            "isFinish":
                                                                                false
                                                                          });
                                                                      ;
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
                                                                            .inventroyList[
                                                                                index]
                                                                            .list
                                                                            ?.where((element) =>
                                                                                element.assetInventoryStatus ==
                                                                                INVENTORY_WAITING_UPLOAD)
                                                                            .length ??
                                                                        0,
                                                                    callback:
                                                                        () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .INVENTORY_TASKLIST_SUB_LEVEL,
                                                                          arguments: {
                                                                            'taskNo':
                                                                                '${controller.inventroyList[index].taskNo}',
                                                                            'bindStatus':
                                                                                [
                                                                              INVENTORY_WAITING_UPLOAD
                                                                            ],
                                                                            "isFinish":
                                                                                false
                                                                          });
                                                                      ;
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
                                                                            .inventroyList[
                                                                                index]
                                                                            .list
                                                                            ?.where((element) =>
                                                                                element.assetInventoryStatus ==
                                                                                INVENTORY_HAVE_UPLOADED)
                                                                            .length ??
                                                                        0,
                                                                    callback:
                                                                        () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .INVENTORY_TASKLIST_SUB_LEVEL,
                                                                          arguments: {
                                                                            'taskNo':
                                                                                '${controller.inventroyList[index].taskNo}',
                                                                            'bindStatus':
                                                                                [
                                                                              INVENTORY_HAVE_UPLOADED
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
                                                Get.toNamed(
                                                    Routes
                                                        .INVENTORY_TASKLIST_SUB_LEVEL,
                                                    arguments: {
                                                      'taskNo':
                                                          '${controller.inventroyList[index].taskNo}',
                                                      'bindStatus': [
                                                        INVENTORY_STATUS_NOT,
                                                        INVENTORY_WAITING_UPLOAD,
                                                        INVENTORY_HAVE_UPLOADED
                                                      ],
                                                      "isFinish": false
                                                    })
                                              },
                                            ),
                                          )),
                                      itemCount: homeController.inventoryList
                                              .value.data?.length ??
                                          0)
                              : homeController.inventoryFinishedList?.length ==
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
                                                        '${homeController.inventoryFinishedList?[index]?.taskNo}',
                                                        style:
                                                            textBoldNumberStyle()),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topStart,
                                                            child: Text(
                                                                '盘点年份：${homeController.inventoryFinishedList?[index]?.inventoryYear}',
                                                                style:
                                                                    textNormalListTextStyle()),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topEnd,
                                                            child: Text(
                                                                '盘点类型：${homeController.inventoryFinishedList?[index]?.inventoryTypeText}',
                                                                style:
                                                                    textNormalListTextStyle()),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topStart,
                                                            child: Text(
                                                                '截止日期：${homeController.inventoryFinishedList?[index]?.endDate}',
                                                                style:
                                                                    textNormalListTextStyle()),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topEnd,
                                                            child: Text(
                                                                '盘点总数：${homeController.inventoryFinishedList?[index]?.inventoryTotal}',
                                                                style:
                                                                    textNormalListTextStyle()),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                            onTap: () => {
                                              Get.toNamed(
                                                  Routes
                                                      .INVENTORY_TASKLIST_SUB_LEVEL,
                                                  arguments: {
                                                    'taskNo':
                                                        '${homeController.inventoryFinishedList?[index]?.taskNo}',
                                                    'bindStatus': [
                                                      INVENTORY_STATUS_NOT,
                                                      INVENTORY_WAITING_UPLOAD,
                                                      INVENTORY_HAVE_UPLOADED
                                                    ],
                                                    "isFinish": true
                                                  })
                                            },
                                          ))),
                                      itemCount: homeController
                                          .inventoryFinishedList.length)))
                ],
              ),
            )));
  }

  Future<void> _onRefresh() async {
    if (homeController.state.selectedInventoryTab) {
      await homeController.getInventoryList();
      controller.getInventoryList();
      if (await CommonUtils.isConnectNet()) {
        toastInfo(msg: "最新任务已更新");
      }
    } else {
      homeController.state.inventoryFinishedPage = 0;
      await homeController
          .getInventoryFinishedList(homeController.state.inventoryFinishedPage);
    }
    _refreshBindTaskController.refreshCompleted();
    _refreshBindTaskController.loadComplete();
  }

  Future<void> _onLoadMore() async {
    if (!homeController.state.selectedInventoryTab) {
      homeController.state.inventoryFinishedPage++;
      InventoryData inventoryList = await homeController
          .getInventoryFinishedList(homeController.state.inventoryFinishedPage);

      if (inventoryList.data != null &&
          inventoryList.data?.length == PAGE_SIZE) {
        _refreshBindTaskController.loadComplete();
      } else {
        _refreshBindTaskController.loadNoData();
      }
    }
  }
}
