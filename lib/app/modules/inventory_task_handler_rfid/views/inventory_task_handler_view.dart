import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../style/text_style.dart';
import '../../../values/constants.dart';
import '../controllers/inventory_task_handler_controller.dart';

/**
 * 盘点操作 RFID 方式盘点
 */
class InventoryTaskHandlerView extends GetView<InventoryTaskHandlerController> {
  var taskNo = Get.arguments['taskNo'];
  @override
  Widget build(BuildContext context) {
    controller.findByParams(taskNo);
    return Scaffold(
      appBar: AppBar(
        title: Text('读取盘点'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () => {controller.saveInfo(taskNo)},
              icon: Icon(Icons.save_alt_sharp),
              color: Colors.blue),
        ],
      ),
      body: Obx(
        () => Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          ListView.builder(
            itemBuilder: ((context, index) => Card(
                  elevation: CARD_ELEVATION,
                  shadowColor: Colors.grey,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${controller.inventoryTaskHandle?[index]?.assetName}',
                            style: textBoldNumberBlueStyle()),
                        Divider(
                          color: Colors.white54,
                          thickness: 1,
                        ),
                        Text(
                            '固定资产编号:${controller.inventoryTaskHandle?[index]?.assetNo}',
                            style: textNormalListTextStyle()),
                        Text(
                            '标签编号:${controller.inventoryTaskHandle?[index]?.labelNo}',
                            style: textNormalListTextStyle()),
                      ],
                    ),
                  ),
                )),
            itemCount: controller.inventoryTaskHandle?.length,
          ),
          Obx(
            () => Stack(
              children: [
                Center(
                    child: Visibility(
                  visible: !controller.isRfidReadStatus.value,
                  child: Text(
                    '请点击设备左侧或右侧按钮扫描',
                    style: textNormalListTextStyle(),
                  ),
                )),
                Center(
                  child: Visibility(
                    visible: controller.isRfidReadStatus.value,
                    child: ElevatedButton(
                        onPressed: () => {
                              if (controller.locationInfo.value.address == null)
                                {controller.getGpsLagLng()}
                              else
                                {controller.startReadRfidData(taskNo)}
                            },
                        child: Text(
                            controller.isReadData.value ? '开始读取' : '结束读取')),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
