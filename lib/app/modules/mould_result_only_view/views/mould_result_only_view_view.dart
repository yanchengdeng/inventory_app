import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/values/size.dart';

import '../../../entity/MouldBindTask.dart';
import '../../../style/text_style.dart';
import '../../../utils/logger.dart';
import '../controllers/mould_result_only_view_controller.dart';

///只查看模具信息  直接对象传入进来显示
///每次查看图片 都需要再次获取token 来拼接图片地址
class MouldResultOnlyViewView extends GetView<MouldResultOnlyViewController> {
  @override
  Widget build(BuildContext context) {
    var info = Get.arguments;
    MouldList? assertBindTaskInfo = MouldList.fromJson(info);

    controller.setMouldBindData(assertBindTaskInfo);
    Log.d("传入只读显示页：info =${info}");

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
                          '固定资产编号：${controller.mouldBindTaskFinished.value.assetNo}',
                          style: textBoldNumberWhiteStyle()),
                      Text(
                          'SGM车型：${controller.mouldBindTaskFinished.value.vehicle}',
                          style: textLitleWhiteTextStyle()),
                      Text(
                          '零件号：${controller.mouldBindTaskFinished.value.moldNo}',
                          style: textLitleWhiteTextStyle()),
                      Text(
                          '工装&模具名称：${controller.mouldBindTaskFinished.value.toolingName}',
                          style: textLitleWhiteTextStyle()),
                      Obx(() => (Visibility(
                          visible: controller.isShowAllInfo.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '工装&模具尺寸(mm)：${controller.mouldBindTaskFinished.value.toolingSize}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装&模具重量(kg)：${controller.mouldBindTaskFinished.value.toolingWeight}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '使用单位：${controller.mouldBindTaskFinished.value.usedUnits}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '制造单位：${controller.mouldBindTaskFinished.value.manufactureUnits}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装模具寿命：${controller.mouldBindTaskFinished.value.assetLifespan}',
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
          color: Colors.white,
          height: 160,
        ),
        Obx(() => Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.red,
                    size: 10,
                  ),
                  Text('标签编号', style: textBoldNumberBlueStyle()),
                  Text(
                    '(${controller.mouldBindTaskFinished.value.lat ?? "0.0"}-${controller.mouldBindTaskFinished.value.lng ?? "0.0"})',
                    style: textNormalListTextStyle(),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Divider(color: Colors.black26, height: 1)),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                            padding:
                                EdgeInsetsDirectional.only(top: 2, bottom: 2),
                            child: Text(
                              '${controller.mouldBindTaskFinished.value.bindLabels?[index]}',
                              style: textNormalListTextStyle(),
                            ),
                          ),
                      itemCount: controller
                          .mouldBindTaskFinished.value.bindLabels?.length)),
            ]))),
        Divider(color: Colors.black12, thickness: 20.0),
        Obx(
          () => Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.red,
                      size: 10,
                    ),
                    Text('资产图片', style: textBoldNumberBlueStyle()),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Divider(color: Colors.black26, height: 1)),
                Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ImageContain())
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget ImageContain() {
    ///标签类型 只显示 铭牌   如果是传整个json 过来 则无 taskType 直接用 是否有标签id 判断
    if (Get.arguments['taskType'] == MOULD_TASK_TYPE_LABEL.toString() ||
        controller.mouldBindTaskFinished.value.labelReplaceTaskId != 0) {
      if (controller.mouldBindTaskFinished.value.nameplatePhoto?.fullPath
              ?.isNotEmpty ==
          true) {
        return textImageWidget(
            '铭牌照片',
            controller.mouldBindTaskFinished.value.nameplatePhoto?.fullPath ??
                "");
      } else {
        return Icon(Icons.hourglass_empty);
      }
    } else {
      /// 支付类型的  /// 支付类型 整体照片、铭牌照片、型腔照片
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: textImageWidget(
                      '整体照片',
                      controller.mouldBindTaskFinished.value.overallPhoto
                              ?.fullPath ??
                          "")),
              Expanded(
                  flex: 1,
                  child: textImageWidget(
                      '铭牌照片',
                      controller.mouldBindTaskFinished.value.nameplatePhoto
                              ?.fullPath ??
                          "")),
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: textImageWidget(
                      '型腔照片',
                      controller.mouldBindTaskFinished.value.cavityPhoto
                              ?.fullPath ??
                          "")),
              Expanded(flex: 1, child: Text('')),
            ],
          ),
        ],
      );
    }
  }

  ///文字 图片混合组件
  Widget textImageWidget(String title, String imageUrl) {
    return Container(
      child: Column(
        children: [
          Container(
              margin: EdgeInsetsDirectional.only(top: 10, bottom: 10),
              child: Text(title, style: textNormalListTextStyle())),
          CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: controller.getNetImageUrl(imageUrl),
              height: SizeConstant.IAMGE_SIZE_HEIGHT,
              width: SizeConstant.IAMGE_SIZE_HEIGHT)
        ],
      ),
    );
  }
}
