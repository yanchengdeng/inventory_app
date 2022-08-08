import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../style/text_style.dart';
import '../../../utils/cache.dart';
import '../../../utils/logger.dart';
import '../../../values/constants.dart';
import '../../../widgets/input.dart';
import '../controllers/inventory_tasklist_sub_level_controller.dart';

class InventoryTasklistSubLevelView
    extends GetView<InventoryTasklistSubLevelController> {
  @override
  Widget build(BuildContext context) {
    var taskNo = Get.arguments['taskNo'];
    var bindStatus = Get.arguments['bindStatus'];
    var isFinish = Get.arguments['isFinish'];
    Log.d(
        "传入二级盘点菜单参数：taskNo = $taskNo,bindStatus = ${bindStatus},isFinish = ${isFinish}");
    controller.findByParams(isFinish, taskNo, '', [bindStatus], []);
    //

    return Scaffold(
        appBar: AppBar(
          title: Text('资产盘点'),
          centerTitle: true,
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
              Container(
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

              ///https://github.com/peng8350/flutter_pulltorefresh/issues/572  这里需要加入Expanded 避免该issue
              Obx(() => Container(
                      child: Expanded(
                    child: ListView.builder(
                      itemBuilder: ((context, index) => Card(
                            elevation: CARD_ELEVATION,
                            shadowColor: Colors.grey,
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
                                            .inventoryTaskListSearch?[index]
                                            ?.assetInventoryStatus),
                                        Text(
                                            '${controller.inventoryTaskListSearch?[index]?.assetNo}',
                                            style: textNormalListTextStyle())
                                      ],
                                    ),
                                    Spacer(flex: 1),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 8, right: 0, bottom: 8),
                                    child: Divider(
                                      color: Colors.grey,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                      '资产名称:${controller.inventoryTaskListSearch?[index]?.assetName}',
                                      style: textNormalListTextStyle()),
                                  Text(
                                      '标签编号:${controller.inventoryTaskListSearch?[index]?.labelNo}',
                                      style: textNormalListTextStyle()),
                                  Text(
                                      'SGM车型：${controller.inventoryTaskListSearch?[index]?.toolingType}',
                                      style: textNormalListTextStyle()),
                                  Text(
                                      '工装模具存使用地:${controller.inventoryTaskListSearch?[index]?.usedArea}',
                                      style: textNormalListTextStyle())
                                ],
                              ),
                            ),
                          )),
                      itemCount: controller.inventoryTaskListSearch?.length,
                    ),
                  )))
            ],
          ),
        ));
  }

  /// 根据绑定状态输入不同颜色
  getTextByStatus(int status) {
    var style = textLitleBlackTextStyle();
    if (status == INVENTORY_STATUS_NOT) {
      style = textLitleOrangeTextStyle();
    } else if (status == INVENTORY_WAITING_UPLOAD) {
      style = textLitleBlackTextStyle();
    }

    return Text('${INVENTORY_STATUS[status]}', style: style);
  }
}
