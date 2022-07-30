import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
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
    CacheUtils.to.getInventoryTaskListByKeyOrStatus(
        isFinish, taskNo, '', [bindStatus], []);
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
                        CacheUtils.to.mouldSearchKey = value;
                        CacheUtils.to.getInventoryTaskListByKeyOrStatus(
                            Get.arguments['isFinish'],
                            Get.arguments['taskNo'],
                            '',
                            [-1],
                            []);
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
                                        getTextByStatus(CacheUtils
                                            .to
                                            .inventoryTaskListSearch
                                            ?.list[index]
                                            ?.assetInventoryStatus),
                                        Text(
                                            '${CacheUtils.to.inventoryTaskListSearch?.list[index]?.assetNo}',
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
                                      '资产名称:${CacheUtils.to.inventoryTaskListSearch?.list[index]?.assetName}',
                                      style: textNormalListTextStyle()),
                                  Text(
                                      '标签编号:${CacheUtils.to.inventoryTaskListSearch?.list[index]?.labelNo}',
                                      style: textNormalListTextStyle()),
                                  Text(
                                      'SGM车型：${CacheUtils.to.inventoryTaskListSearch?.list[index]?.toolingType}',
                                      style: textNormalListTextStyle()),
                                  Text(
                                      '工装模具存使用地:${CacheUtils.to.inventoryTaskListSearch?.list[index]?.usedArea}',
                                      style: textNormalListTextStyle())
                                ],
                              ),
                            ),
                          )),
                      itemCount:
                          CacheUtils.to.inventoryTaskListSearch?.list?.length,
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
