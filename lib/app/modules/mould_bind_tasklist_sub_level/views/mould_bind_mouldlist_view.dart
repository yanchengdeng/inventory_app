import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/MouldBindTask.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/widgets/empty.dart';
import 'package:inventory_app/app/widgets/widgets.dart';
import '../../../style/text_style.dart';
import '../../../utils/logger.dart';
import '../../../values/constants.dart';
import '../../../widgets/menu/flutter_down_menu.dart';
import '../controllers/mould_bind_mouldlist_controller.dart';

///  模具绑定任务信息列表
class MouldBindMouldListView extends GetView<MouldBindMouldListController> {
  var statusTitles = '全部';
  var toolTypes = TOOL_TYPES.map((e) => e.name ?? '').toList();
  @override
  Widget build(BuildContext context) {
    var taskNo = Get.arguments['taskNo'];
    var taskType = Get.arguments['taskType'];
    var bindStatus = Get.arguments['bindStatus'];
    var isFinish = Get.arguments['isFinish'];
    Log.d(
        "传入二级模具菜单参数：taskNo = $taskNo,taskType = ${taskType},bindStatus = ${bindStatus},isFinish = ${isFinish}");

    ///初始化选中值
    if (bindStatus is List) {
      if (bindStatus.length == 4) {
        ///全选
        SELECT_STATUS.forEach((element) {
          element.isSelect = true;
        });
        statusTitles = '全部';
      } else {
        SELECT_STATUS.forEach((element) {
          if (element.code == bindStatus[0]) {
            element.isSelect = true;
            statusTitles = element.name ?? '全部';
          }
        });
      }
    }

    TOOL_TYPES.forEach((element) {
      element.isSelect = true;
    });

    controller.findByParams(isFinish, taskNo, '', bindStatus, toolTypes);

    Get.put(MouldBindMouldListController());

    final MenuController _menuController = MenuController();

    return Scaffold(
      appBar: AppBar(
        title: Text('模具绑定'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: inputTextEdit(
                  hintText: '搜资产编号、名称',
                  inputOnSubmit: (value) {
                    controller.findByParams(
                        isFinish, taskNo, value, bindStatus, toolTypes);
                  })),
          DropDownMenuHeader(
              menuController: _menuController, titles: [statusTitles, "工装类型"]),
          Expanded(
            child: Stack(
              children: [
                Obx(
                  () => controller.mouldBindTaskListSearch?.length == 0
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
                                        Row(children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getTextByStatus(controller
                                                      .mouldBindTaskListSearch[
                                                          index]
                                                      ?.bindStatus ??
                                                  BIND_STATUS_WAITING_BIND),
                                              Text(
                                                  '${controller.mouldBindTaskListSearch?[index]?.assetNo}',
                                                  style:
                                                      textNormalListTextStyle())
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
                                                              "taskType": Get
                                                                      .arguments[
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
                                            '标签编号:${getLabelInfo(controller.mouldBindTaskListSearch?[index])}',
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
                                    if (controller
                                            .mouldBindTaskListSearch?[index]
                                            ?.bindStatus ==
                                        BIND_STATUS_UPLOADED)
                                      {
                                        ///已上传（已完成和未完成模具中都有）
                                        Get.toNamed(
                                            Routes.MOULD_RESULT_ONLY_VIEW,
                                            arguments: controller
                                                .mouldBindTaskListSearch?[index]
                                                ?.toJson())
                                      }
                                    else
                                      {
                                        ///其他状态直接打开编辑上传页
                                        Get.toNamed(Routes.MOULD_READ_RESULT,
                                            arguments: {
                                              "taskType":
                                                  Get.arguments['taskType'],
                                              "taskNo": Get.arguments['taskNo'],
                                              "assetNo": controller
                                                  .mouldBindTaskListSearch?[
                                                      index]
                                                  .assetNo
                                            })
                                      }
                                  },
                                ),
                              )),
                          itemCount: controller.mouldBindTaskListSearch?.length,
                        ),
                ),
                DropDownMenu(
                    height: 300,
                    milliseconds: 300,
                    children: [
                      MenuList(
                        index: 0,
                        choose: Choose.multi,
                        menuController: _menuController,
                        filterList: SELECT_STATUS,
                        onTap: (index) {
                          var statusStr = _menuController.title;
                          var status = statusTitles.split(',');
                          bindStatus = SELECT_STATUS
                              .where((element) => _menuController.title
                                  .contains(element.name ?? ''))
                              .map((e) => e.code ?? -1)
                              .toList();
                          controller.findByParams(
                              isFinish, taskNo, '', bindStatus, toolTypes);
                        },
                      ),
                      MenuList(
                        index: 1,
                        choose: Choose.multi,
                        menuController: _menuController,
                        filterList: TOOL_TYPES,
                        onTap: (index) {
                          toolTypes = TOOL_TYPES
                              .where((element) => _menuController.title
                                  .contains(element.name ?? ''))
                              .toList()
                              .map((e) => e.name ?? '')
                              .toList();

                          controller.findByParams(
                              isFinish, taskNo, '', bindStatus, toolTypes);
                        },
                      )
                    ],
                    menuController: _menuController)
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !isFinish,
        child: FloatingActionButton(
          onPressed: () async {
            if (await CommonUtils.isConnectNet()) {
              controller.doUploadData(taskType);
            } else {
              toastInfo(msg: '网络异常，无法上传');
            }
          },
          backgroundColor: Colors.blue,
          child: Text('上传'),
        ),
      ),
    );
  }

  /// 根据绑定状态输入不同颜色
  getTextByStatus(int status) {
    var style = textLitleBlackTextStyle();
    if (status == BIND_STATUS_WAITING_BIND) {
      style = textLitleOrangeTextStyle();
    } else if (status == BIND_STATUS_REBIND) {
      style = textLitleRedTextStyle();
    } else if (status == BIND_STATUS_UPLOADED) {
      style = textLitleBlueTextStyle();
    } else if (status == BIND_STATUS_WAITING_UPLOAD) {
      style = textLitleGreenTextStyle();
    }

    return Text('${MOULD_BIND_STATUS[status]}', style: style);
  }

  ///3.1.2若以下照片有一张缺少，在标签编号最后提示：（缺照片）；不缺少则不显示提示
  /// 3.1.2.1支付任务类型+模具工装类型为M：整体照片、铭牌照片、型腔照片
  /// 3.1.2.2支付任务类型+模具工装类型为F/G：整体照片、铭牌照片
  /// 3.1.2.3标签替换任务类型：铭牌照片
  String getLabelInfo(MouldList? mouldList) {
    if (mouldList != null) {
      if (mouldList.labelType == MOULD_TASK_TYPE_PAY) {
        if (mouldList.toolingType == TOOL_TYPE_M) {
          if (mouldList.cavityPhoto != null &&
              mouldList.cavityPhoto?.fullPath?.isNotEmpty == true &&
              mouldList.nameplatePhoto != null &&
              mouldList.nameplatePhoto?.fullPath?.isNotEmpty == true &&
              mouldList.overallPhoto != null &&
              mouldList.overallPhoto?.fullPath?.isNotEmpty == true) {
            return getLabelStr(mouldList.bindLabels);
          } else {
            return getLabelStr(mouldList.bindLabels) + "(缺照片)";
          }
        } else {
          if (mouldList.nameplatePhoto != null &&
              mouldList.overallPhoto != null) {
            return getLabelStr(mouldList.bindLabels);
          } else {
            return getLabelStr(mouldList.bindLabels) + "(缺照片)";
          }
        }
      } else {
        if (mouldList.nameplatePhoto != null) {
          return getLabelStr(mouldList.bindLabels);
        } else {
          return getLabelStr(mouldList.bindLabels) + "(缺照片)";
        }
      }
    } else {
      return " - (缺照片) ";
    }
  }

  String getLabelStr(List<String>? labels) {
    if (labels != null && labels.length > 0) {
      if (labels.length == 1) {
        return labels[0];
      } else {
        return labels[0] + ' ...';
      }
    } else {
      return " - ";
    }
  }
}
