import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/modules/home/controllers/home_controller.dart';
import 'package:inventory_app/app/style/style.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../values/fontsize.dart';
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
                          //接口无分页 禁止上拉加载更多
                          onRefresh: _onRefresh,
                          child:homeController.state.selectedTab?

                          ListView.builder(
                            itemBuilder: ((context, index) => Card(
                                child: Center(
                                    child: Text(
                                        '未完成：${homeController.state.mouldBindTaskList?.data.unfinishedTaskList?[index].distributionTime}')))),
                            itemCount: homeController.state.mouldBindTaskList
                                ?.data?.unfinishedTaskList?.length,
                            itemExtent: 100,
                          ): ListView.builder(
                            itemBuilder: ((context, index) => Card(
                                child: Center(
                                    child: Text(
                                        '已完成：${homeController.state.mouldBindTaskList?.data.finishedTaskList?[index].distributionTime}')))),
                            itemCount: homeController.state.mouldBindTaskList
                                ?.data?.finishedTaskList?.length,
                            itemExtent: 100,
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
