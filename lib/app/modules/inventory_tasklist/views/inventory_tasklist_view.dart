import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
                              text:
                                  '未完成(${CacheUtils.to.inventoryList?.unfinished})',
                              selected: homeController.state.selectedTab,
                              isLeft: true,
                              callback: () {
                                if (!homeController.state.selectedTab) {
                                  homeController.state.selectedTab =
                                      !homeController.state.selectedTab;
                                }
                              }),
                          flex: 1,
                        ),
                        Expanded(
                          child: selectTabView(
                              text:
                                  '已完成(${CacheUtils.to.inventoryList?.finished})',
                              selected: !homeController.state.selectedTab,
                              isLeft: false,
                              callback: () {
                                if (homeController.state.selectedTab) {
                                  homeController.state.selectedTab =
                                      !homeController.state.selectedTab;
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
                                                    '${CacheUtils.to.inventoryList?.unfinishedList?[index]?.taskNo}',
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
                                                            '盘点年份：${CacheUtils.to.inventoryList?.finishedList?[index]?.distributionTime.substring(0, 4)}',
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
                                                            '盘点类型：${CacheUtils.to.inventoryList?.unfinishedList?[index]?.inventoryTypeText}',
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
                                                            '截止日期：${CacheUtils.to.inventoryList?.unfinishedList?[index]?.endDate}',
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
                                                            '盘点总数：${CacheUtils.to.inventoryList?.unfinishedList?[index]?.inventoryTotal}',
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
                                                                status: '未盘点',
                                                                count: CacheUtils
                                                                    .to
                                                                    .getInventoryListByStatus(
                                                                        index,
                                                                        INVENTORY_STATUS_NOT)
                                                                    .length,
                                                                callback: () {
                                                                  Get.toNamed(
                                                                      Routes
                                                                          .INVENTORY_TASKLIST_SUB_LEVEL,
                                                                      arguments: {
                                                                        'taskNo':
                                                                            '${CacheUtils.to.inventoryList?.unfinishedList?[index]?.taskNo}',
                                                                        'bindStatus':
                                                                            INVENTORY_STATUS_NOT,
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
                                                                status: '待上传',
                                                                count: CacheUtils
                                                                    .to
                                                                    .getInventoryListByStatus(
                                                                        index,
                                                                        INVENTORY_WAITING_UPLOAD)
                                                                    .length,
                                                                callback: () {
                                                                  Get.toNamed(
                                                                      Routes
                                                                          .INVENTORY_TASKLIST_SUB_LEVEL,
                                                                      arguments: {
                                                                        'taskNo':
                                                                            '${CacheUtils.to.inventoryList?.unfinishedList?[index]?.taskNo}',
                                                                        'bindStatus':
                                                                            INVENTORY_WAITING_UPLOAD,
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
                                                                status: '已上传',
                                                                count: CacheUtils
                                                                    .to
                                                                    .getInventoryListByStatus(
                                                                        index,
                                                                        INVENTORY_HAVE_UPLOADED)
                                                                    .length,
                                                                callback: () {
                                                                  Get.toNamed(
                                                                      Routes
                                                                          .INVENTORY_TASKLIST_SUB_LEVEL,
                                                                      arguments: {
                                                                        'taskNo':
                                                                            '${CacheUtils.to.inventoryList?.unfinishedList?[index]?.taskNo}',
                                                                        'bindStatus':
                                                                            INVENTORY_HAVE_UPLOADED,
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
                                                      '${CacheUtils.to.inventoryList?.unfinishedList?[index]?.taskNo}',
                                                  'bindStatus':
                                                      INVENTORY_STATUS_ALL,
                                                  "isFinish": false
                                                })
                                          },
                                        ),
                                      )),
                                  itemCount:
                                      CacheUtils.to.inventoryList?.unfinished)
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
                                                    '${CacheUtils.to.inventoryList?.finishedList?[index]?.taskNo}',
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
                                                            '盘点年份：${CacheUtils.to.inventoryList?.finishedList?[index]?.distributionTime.substring(0, 4)}',
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
                                                            '盘点类型：${CacheUtils.to.inventoryList?.finishedList?[index]?.inventoryTypeText}',
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
                                                            '截止日期：${CacheUtils.to.inventoryList?.finishedList?[index]?.endDate}',
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
                                                            '盘点总数：${CacheUtils.to.inventoryList?.finishedList?[index]?.inventoryTotal}',
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
                                                    '${CacheUtils.to.inventoryList?.finishedList?[index]?.taskNo}',
                                                'bindStatus':
                                                    INVENTORY_STATUS_ALL,
                                                "isFinish": true
                                              })
                                        },
                                      ))),
                                  itemCount:
                                      CacheUtils.to.inventoryList?.finished)))
                ],
              ),
            )));
  }

  Future<void> _onRefresh() async {
    await homeController.getInventoryList();
    _refreshBindTaskController.refreshCompleted();
    toastInfo(msg: "最新任务已更新");
  }
}
