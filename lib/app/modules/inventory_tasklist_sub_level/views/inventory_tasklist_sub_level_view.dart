import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/widgets/toast.dart';
import '../../../style/text_style.dart';
import '../../../utils/common.dart';
import '../../../utils/logger.dart';
import '../../../values/constants.dart';
import '../../../widgets/empty.dart';
import '../../../widgets/input.dart';
import '../../../widgets/menu/flutter_down_menu.dart';
import '../controllers/inventory_tasklist_sub_level_controller.dart';

/**
 * ///模具任务状态  -1  默认全部状态
const int BIND_STATUS_ALL = -1;
const int BIND_STATUS_WAITING_BIND = 0;
const int BIND_STATUS_REBIND = 1;
const int BIND_STATUS_UPLOADED = 2;
const int BIND_STATUS_WAITING_UPLOAD = 3;

const MOULD_BIND_STATUS = {
  BIND_STATUS_ALL: '全部',
  BIND_STATUS_WAITING_BIND: '待绑定',
  BIND_STATUS_REBIND: '重新绑定',
  BIND_STATUS_UPLOADED: '已上传',
  BIND_STATUS_WAITING_UPLOAD: '待上传'
};
 */
class InventoryTasklistSubLevelView
    extends GetView<InventoryTasklistSubLevelController> {
  final MenuController _menuController = MenuController();
  final List<FilterRes> list1 = [
    FilterRes(name: 'F'),
    FilterRes(name: 'G'),
    FilterRes(name: 'M')
  ];
  final List<FilterRes> list2 = [
    FilterRes(name: '待绑定', code: BIND_STATUS_WAITING_BIND),
    FilterRes(name: '重新绑定', code: BIND_STATUS_REBIND),
    FilterRes(name: '待上传', code: BIND_STATUS_WAITING_UPLOAD),
    FilterRes(name: '已上传', code: BIND_STATUS_UPLOADED)
  ];

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
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: inputTextEdit(
                    hintText: '搜资产编号、名称',
                    inputOnSubmit: (value) {
                      controller.findByParams(
                          isFinish, taskNo, value, [bindStatus], []);
                    })),
            DropDownMenuHeader(
                menuController: _menuController, titles: const ["全部", "工装类型"]),
            Expanded(
              child: Stack(
                children: [
                  Obx(() => Container(
                        child: controller.inventoryTaskSearch.length == 0
                            ? DefaultEmptyWidget()
                            : ListView.builder(
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
                                                style:
                                                    textNormalListTextStyle()),
                                            Text(
                                                '标签编号:${controller.inventoryTaskSearch[index].labelNo}',
                                                style:
                                                    textNormalListTextStyle()),
                                            Text(
                                                'SGM车型：${controller.inventoryTaskSearch[index].toolingType}',
                                                style:
                                                    textNormalListTextStyle()),
                                            Text(
                                                '工装模具存使用地:${controller.inventoryTaskSearch[index].usedArea}',
                                                style:
                                                    textNormalListTextStyle())
                                          ],
                                        ),
                                      ),
                                    )),
                                itemCount:
                                    controller.inventoryTaskSearch.length,
                              ),
                      )),
                  DropDownMenu(
                      height: 300,
                      milliseconds: 300,
                      children: [
                        MenuList(
                          index: 0,
                          choose: Choose.multi,
                          menuController: _menuController,
                          filterList: list1,
                          onTap: (index) {
                            toastInfo(msg: list1[index].name ?? "hh");
                          },
                        ),
                        MenuList(
                          index: 1,
                          choose: Choose.multi,
                          menuController: _menuController,
                          filterList: list2,
                          onTap: (index) {
                            toastInfo(msg: list2[index].name ?? "hh");
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
          child: Container(
            margin: EdgeInsetsDirectional.only(bottom: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                FloatingActionButton(
                  child: Text('读取\n盘点'),
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
                  child: Text('扫描\n盘点'),
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
                  child: Text('上传'),
                  // 设置 tag3
                  heroTag: 'tag3',
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    if (await CommonUtils.isConnectNet()) {
                      controller.upload();
                    } else {
                      toastInfo(msg: '网络异常，无法上传');
                    }
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
