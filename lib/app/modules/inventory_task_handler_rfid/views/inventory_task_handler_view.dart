import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/services/location.dart';
import 'package:inventory_app/app/widgets/toast.dart';
import '../../../style/text_style.dart';
import '../../../values/constants.dart';
import '../controllers/inventory_task_handler_controller.dart';

/**
 * 盘点操作 RFID 方式盘点
 */
class InventoryTaskHandlerView extends GetView<InventoryTaskHandlerController> {
  var taskNo = Get.arguments['taskNo'];
  var isRfidType = Get.arguments['isRFID'];
  @override
  Widget build(BuildContext context) {
    controller.findByParams(taskNo);
    return WillPopScope(
      onWillPop: () async {
        controller.saveInfo(taskNo);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('读取盘点'),
            centerTitle: true,
          ),
          body: Obx(
            () => ListView.builder(
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
          ),
          floatingActionButton: Obx(() => Container(
                height: 100,
                margin: EdgeInsetsDirectional.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !controller.isRfidReadStatus.value,
                      child: Container(
                        margin:
                            EdgeInsetsDirectional.only(start: 40, bottom: 10),
                        child: Text(
                          "请点击设备左侧或右侧按钮扫描",
                          style: textLitleBlackTextStyle(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Spacer(),
                        Visibility(
                          visible: controller.isRfidReadStatus.value,
                          child: FloatingActionButton(
                            child:
                                Text(controller.isReadData.value ? '读取' : '停止'),
                            backgroundColor: Colors.orange,
                            // 设置 tag1
                            heroTag: 'tag1',
                            onPressed: () {
                              if (LocationMapService
                                      .to.locationResult.value.address ==
                                  null) {
                                controller.getGpsLagLng();
                              } else {
                                controller.locationInfo.value =
                                    LocationMapService.to.locationResult.value;
                                controller.startReadRfidData(taskNo);
                              }
                            },
                          ),
                        ),
                        Spacer(),
                        FloatingActionButton(
                          child: Text('保存'),
                          // 设置 tag2
                          heroTag: 'tag2',
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            controller.saveInfo(taskNo);
                          },
                        ),
                        Spacer(),
                        FloatingActionButton(
                          child: Text('上传'),
                          // 设置 tag2
                          heroTag: 'tag3',
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            toastInfo(msg: '待验证');
                            // controller.upload();
                          },
                        ),
                        Spacer()
                      ],
                    ),
                  ],
                ),
              ))),
    );
  }
}
