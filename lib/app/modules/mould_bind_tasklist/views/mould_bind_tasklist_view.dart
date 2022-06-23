
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../controllers/mould_bind_tasklist_controller.dart';

/**
 * 模具绑定列表
 */
class MouldBindTasklistView extends GetView<MouldBindTasklistController> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('模具绑定列表'),
          centerTitle: true,
        ),
        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: false, //接口无分页 禁止上拉加载更多
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: ((context, index) => Card(
                  child: Center(
                      child: Text(
                          '数据为：${controller.mouldBindList.data?.finishedTaskList?[index].distributionTime}')))),
              itemCount:
                  controller.mouldBindList.data?.finishedTaskList?.length,
              itemExtent: 100,
            )));
  }

  void _onRefresh() {
    controller.getMouldTaskList();
    _refreshController.refreshCompleted();
  }



  // Widget MouldBindTasklistView(int index){
  //   return const Text('data');
  //   // return Card(child: Center(child: Text('数据为：${controller.mouldBindList.data?.finishedTaskList?[index].distributionTime}')));
  // }
}



