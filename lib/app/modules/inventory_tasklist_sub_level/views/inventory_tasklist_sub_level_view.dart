import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/widgets/toast.dart';
import '../../../style/text_style.dart';
import '../../../utils/logger.dart';
import '../../../values/constants.dart';
import '../../../widgets/empty.dart';
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
                  child: controller.inventoryTaskSearch.length == 0
                      ? DefaultEmptyWidget()
                      : Expanded(
                          child: ListView.builder(
                            itemBuilder: ((context, index) => Card(
                                  elevation: CARD_ELEVATION,
                                  shadowColor: Colors.grey,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Obx(() => Text(
                                                '${controller.inventoryTaskSearch[index].assetNo}',
                                                style:
                                                    textNormalListTextStyle())),
                                            Spacer(),
                                            getTextByStatus(controller
                                                .inventoryTaskSearch[index]
                                                .assetInventoryStatus)
                                          ],
                                        ),
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
                                            '资产名称:${controller.inventoryTaskSearch[index].assetName}',
                                            style: textNormalListTextStyle()),
                                        Text(
                                            '标签编号:${controller.inventoryTaskSearch[index].labelNo}',
                                            style: textNormalListTextStyle()),
                                        Text(
                                            'SGM车型：${controller.inventoryTaskSearch[index].toolingType}',
                                            style: textNormalListTextStyle()),
                                        Text(
                                            '工装模具存使用地:${controller.inventoryTaskSearch[index].usedArea}',
                                            style: textNormalListTextStyle())
                                      ],
                                    ),
                                  ),
                                )),
                            itemCount: controller.inventoryTaskSearch.length,
                          ),
                        )))
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: !isFinish,
          child: Container(
            margin: EdgeInsetsDirectional.only(bottom: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                FloatingActionButton(
                  child: Text('RFID\n读取'),
                  backgroundColor: Colors.orange,
                  // 设置 tag1
                  heroTag: 'tag1',
                  onPressed: () {
                    Get.toNamed(Routes.INVENTORY_TASK_HANDLER,
                        arguments: {'taskNo': taskNo, 'isRFID': true});
                  },
                ),
                Spacer(),
                FloatingActionButton(
                  child: Text('PDA\n扫描'),
                  backgroundColor: Colors.green,
                  // 设置 tag2
                  heroTag: 'tag2',
                  onPressed: () {
                    Get.toNamed(Routes.INVENTORY_TASK_HANDLER,
                        arguments: {'taskNo': taskNo, 'isRFID': false});
                  },
                ),
                Spacer(),
                FloatingActionButton(
                  child: Text('数据\n上传'),
                  // 设置 tag3
                  heroTag: 'tag3',
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    controller.upload();
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  /// 根据绑定状态输入不同颜色
  getTextByStatus(int? status) {
    var style = textLitleBlackTextStyle();
    if (status == INVENTORY_STATUS_NOT) {
      style = textLitleOrangeTextStyle();
    } else if (status == INVENTORY_WAITING_UPLOAD) {
      style = textLitleGreenTextStyle();
    } else if (status == INVENTORY_WAITING_UPLOAD) {
      style = textLitleBlueTextStyle();
    }

    return Text('${INVENTORY_STATUS[status]}', style: style);
  }
}
