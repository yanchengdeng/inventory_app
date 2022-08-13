import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/MouldBindTask.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/widgets/widgets.dart';

import '../../../style/text_style.dart';
import '../../../utils/loading.dart';
import '../../../utils/logger.dart';
import '../../../values/constants.dart';
import '../controllers/mould_bind_mouldlist_controller.dart';

///  模具绑定任务信息列表
class MouldBindMouldListView extends GetView<MouldBindMouldListController> {
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
                onPressed: () async => {
                      await controller.doUploadData(taskType),
                      controller.mouldBindTaskListSearch,
                    },
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
                                          getTextByStatus(controller.mouldBindTaskListSearch[index]
                                              ?.bindStatus ?? BIND_STATUS_WAITING_BIND),
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
                                        '标签编号:${getLableInfo(controller.mouldBindTaskListSearch?[index])}',
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
    if (status == BIND_STATUS_WAITING_BIND) {
      style = textLitleOrangeTextStyle();
    } else if (status == BIND_STATUS_REBIND) {
      style = textLitleRedTextStyle();
    } else if (status == BIND_STATUS_UPLOADED) {
      style = textLitleGreenTextStyle();
    } else if (status == BIND_STATUS_WAITING_UPLOAD) {
      style = textLitleBrownTextStyle();
    }

    return Text('${MOULD_BIND_STATUS[status]}', style: style);
  }

  ///3.1.2若以下照片有一张缺少，在标签编号最后提示：（缺照片）；不缺少则不显示提示
  /// 3.1.2.1支付任务类型+模具工装类型为M：整体照片、铭牌照片、型腔照片
  /// 3.1.2.2支付任务类型+模具工装类型为F/G：整体照片、铭牌照片
  /// 3.1.2.3标签替换任务类型：铭牌照片
  String getLableInfo(MouldList? mouldList) {
    if (mouldList != null && (mouldList.bindLabels?.isNotEmpty ?? false)) {
      if (mouldList.labelType == MOULD_TASK_TYPE_PAY &&
          mouldList.toolingType == TOOL_TYPE_M) {
        if (mouldList.cavityPhoto != null &&
            mouldList.nameplatePhoto != null &&
            mouldList.overallPhoto != null) {
          ///TODO  待确定
          return mouldList.bindLabels.toString() ?? "-";
        } else {
          return mouldList.bindLabels.toString() ?? "(缺照片)";
        }
      } else if (mouldList.labelType == MOULD_TASK_TYPE_PAY ||
          mouldList.toolingType == TOOL_TYPE_G) {
        if (mouldList.nameplatePhoto != null &&
            mouldList.overallPhoto != null) {
          return mouldList.bindLabels.toString() ?? "-";
        } else {
          return mouldList.bindLabels.toString() ?? "(缺照片)";
        }
      } else if (mouldList.labelType == MOULD_TASK_TYPE_LABEL) {
        if (mouldList.nameplatePhoto != null) {
          return mouldList.bindLabels.toString() ?? "-";
        } else {
          return mouldList.bindLabels.toString() ?? "(缺照片)";
        }
      } else {
        return mouldList.bindLabels.toString() ?? "-";
      }
    } else {
      return " -(缺照片) ";
    }
  }
}
