import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../style/text_style.dart';
import '../controllers/mould_result_only_view_controller.dart';

///只查看模具信息
class MouldResultOnlyViewView extends GetView<MouldResultOnlyViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('读取结果'),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [bottomInfoWidget(), topInfoWidget()],
          ),
        ),
      ),
    );
  }

  ///顶部信息
  Widget topInfoWidget() {
    return Container(
      margin: EdgeInsetsDirectional.all(10),
      child: Card(
          color: Colors.blue,
          child: Obx(
            () => Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Container(
                  padding: EdgeInsetsDirectional.all(10),
                  alignment: AlignmentDirectional.topStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '固定资产编号：${controller.homeController.state.assertBindTaskInfo?.assetNo}',
                          style: textBoldNumberWhiteStyle()),
                      Text(
                          'SGM车型：${controller.homeController.state.assertBindTaskInfo?.vehicle}',
                          style: textLitleWhiteTextStyle()),
                      Text(
                          '零件号：${controller.homeController.state.assertBindTaskInfo?.moldNo}',
                          style: textLitleWhiteTextStyle()),
                      Text(
                          '工装&模具名称：${controller.homeController.state.assertBindTaskInfo?.toolingName}',
                          style: textLitleWhiteTextStyle()),
                      Obx(() => (Visibility(
                          visible: controller.isShowAllInfo.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '工装&模具尺寸(mm)：${controller.homeController.state.assertBindTaskInfo?.toolingSize}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装&模具重量(kg)：${controller.homeController.state.assertBindTaskInfo?.toolingWeight}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '使用单位：${controller.homeController.state.assertBindTaskInfo?.usedUnits}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '制造单位：${controller.homeController.state.assertBindTaskInfo?.manufactureUnits}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装模具使用模次：${controller.homeController.state.assertBindTaskInfo?.assetNo}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装模具寿命：${controller.homeController.state.assertBindTaskInfo?.assetLifespan}',
                                  style: textLitleWhiteTextStyle()),
                            ],
                          )))),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => {
                    controller.isShowAllInfo.value =
                        !controller.isShowAllInfo.value
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.all(10),
                    child: Obx(() => (controller.isShowAllInfo.value
                        ? Image(
                            image: AssetImage('images/icon_arrow_up.png'),
                            width: 20,
                            height: 20,
                          )
                        : Image(
                            image: AssetImage('images/icon_arrow_down.png'),
                            width: 20,
                            height: 20,
                          ))),
                  ),
                )
              ],
            ),
          )),
    );
  }

  // 底部信息
  Widget bottomInfoWidget() {
    return Column(
      children: [
        Container(
          color: Colors.red,
          height: 130,
        ),
        Obx(
          () => Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.red,
                size: 10,
              ),
              Text('标签编号', style: textBoldNumberBlueStyle()),
              Text(
                '(${controller.homeController.state.assertBindTaskInfo?.lat}-${controller.homeController.state.assertBindTaskInfo?.lng})',
                style: textNormalListTextStyle(),
              ),
              ListView.builder(
                itemCount: controller.homeController.state.assertBindTaskInfo
                    ?.bindLabels?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                      '${controller.homeController.state.assertBindTaskInfo?.bindLabels[index]}');
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
