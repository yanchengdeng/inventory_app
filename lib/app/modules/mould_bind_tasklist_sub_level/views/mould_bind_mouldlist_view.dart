import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/mould_bind.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import '../../../style/text_style.dart';
import '../../../utils/logger.dart';
import '../../../values/constants.dart';
import '../controllers/mould_bind_mouldlist_controller.dart';

///  模具绑定任务信息列表
class MouldBindMouldListView extends GetView<MouldBindMouldlistController> {
  @override
  Widget build(BuildContext context) {
    var taskNo = Get.arguments['taskNo'];
    var taskType = Get.arguments['taskType'];
    var bindStatus = Get.arguments['bindStatus'];
    var isFinish = Get.arguments['isFinish'];
    Log.d(
        "传入二级模具菜单参数：taskNo = $taskNo,taskType = ${taskType},bindStatus = ${bindStatus},isFinish = ${isFinish}");

    controller.findByParams(isFinish, taskNo, '', [bindStatus], []);

    return Scaffold(
        appBar: AppBar(
          title: Text('模具绑定'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => {controller.doUploadData(taskType)},
                icon: Icon(Icons.upload),
                color: Colors.blue)
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: inputTextEdit(
                      hintText: '搜资产编号、名称',
                      inputOnSubmit: (value) {
                        controller.findByParams(
                            isFinish, taskNo, value, [bindStatus], []);
                      })),
              Visibility(
                visible: true,
                child: Container(
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
              ),

              ///https://github.com/peng8350/flutter_pulltorefresh/issues/572  这里需要加入Expanded 避免该issue
              Obx(() => Container(
                      child: Expanded(
                    child: ListView.builder(
                      itemBuilder: ((context, index) => Card(
                            elevation: CARD_ELEVATION,
                            shadowColor: Colors.grey,
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getTextByStatus(controller
                                              .mouldBindTaskListSearch?[index]
                                              ?.bindStatus),
                                          Text(
                                              '${controller.mouldBindTaskListSearch?[index]?.assetNo}',
                                              style: textNormalListTextStyle())
                                        ],
                                      ),
                                      Spacer(flex: 1),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .mouldBindTaskListSearch?[
                                                      index]
                                                  ?.bindStatus !=
                                              BIND_STATUS_UPLOADED,
                                          child: ElevatedButton(
                                              onPressed: () => {
                                                    ///其他状态直接打开编辑上传页
                                                    Get.toNamed(
                                                        Routes
                                                            .MOULD_READ_RESULT,
                                                        arguments: {
                                                          "taskType":
                                                              Get.arguments[
                                                                  'taskType'],
                                                          "taskNo":
                                                              Get.arguments[
                                                                  'taskNo'],
                                                          "assetNo": controller
                                                              .mouldBindTaskListSearch?[
                                                                  index]
                                                              ?.assetNo
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
                                        '标签编号:${controller.mouldBindTaskListSearch?[index]?.bindStatusText}',
                                        style: textNormalListTextStyle()),
                                    Text(
                                        '零件号:${controller.mouldBindTaskListSearch?[index]?.moldNo}',
                                        style: textNormalListTextStyle()),
                                    Text(
                                        '零件名称：${controller.mouldBindTaskListSearch?[index]?.moldName}',
                                        style: textNormalListTextStyle()),
                                    Text(
                                        'SGM车型:${controller.mouldBindTaskListSearch?[index]?.toolingName}',
                                        style: textNormalListTextStyle()),
                                    Text(
                                        '备注：${controller.mouldBindTaskListSearch?[index]?.remark}',
                                        style: textNormalListTextStyle())
                                  ],
                                ),
                              ),
                              onTap: () => {
                                if (controller.mouldBindTaskListSearch?[index]
                                        ?.bindStatus ==
                                    BIND_STATUS_UPLOADED)
                                  {
                                    ///已上传（已完成和未完成模具中都有）

                                    Get.toNamed(Routes.MOULD_RESULT_ONLY_VIEW,
                                        arguments: controller
                                            .mouldBindTaskListSearch?[index]
                                            ?.toJson())
                                  }
                                else
                                  {
                                    ///其他状态直接打开编辑上传页
                                    Get.toNamed(Routes.MOULD_READ_RESULT,
                                        arguments: {
                                          "taskType": Get.arguments['taskType'],
                                          "taskNo": Get.arguments['taskNo'],
                                          "assetNo": controller
                                              .mouldBindTaskListSearch?[index]
                                              .assetNo
                                        })
                                  }
                              },
                            ),
                          )),
                      itemCount: controller.mouldBindTaskListSearch?.length,
                    ),
                  )))
            ],
          ),
        ));
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
