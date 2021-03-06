import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/values/size.dart';

import '../../../entity/mould_bind.dart';
import '../../../style/text_style.dart';
import '../../../utils/logger.dart';
import '../controllers/mould_result_only_view_controller.dart';

///只查看模具信息
class MouldResultOnlyViewView extends GetView<MouldResultOnlyViewController> {
  @override
  Widget build(BuildContext context) {
    var taskNo = Get.arguments['taskNo'];
    var taskType = Get.arguments['taskType'];
    var assetNo = Get.arguments['assetNo'];
    var isFinish = Get.arguments['isFinish'];

    Log.d(
        "传入只读显示页：taskNo = $taskNo,taskType = ${taskType},assetNo = ${assetNo},taskType = ${taskType}");

    isFinish
        ? CacheUtils.to.getAssetBindTaskInfo(taskNo, assetNo)
        : CacheUtils.to.getUnLoadedAssetBindTaskInfo(taskNo, assetNo);

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
                          '固定资产编号：${CacheUtils.to.assertBindTaskInfo?.assetNo}',
                          style: textBoldNumberWhiteStyle()),
                      Text('SGM车型：${CacheUtils.to.assertBindTaskInfo?.vehicle}',
                          style: textLitleWhiteTextStyle()),
                      Text('零件号：${CacheUtils.to.assertBindTaskInfo?.moldNo}',
                          style: textLitleWhiteTextStyle()),
                      Text(
                          '工装&模具名称：${CacheUtils.to.assertBindTaskInfo?.toolingName}',
                          style: textLitleWhiteTextStyle()),
                      Obx(() => (Visibility(
                          visible: controller.isShowAllInfo.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '工装&模具尺寸(mm)：${CacheUtils.to.assertBindTaskInfo?.toolingSize}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装&模具重量(kg)：${CacheUtils.to.assertBindTaskInfo?.toolingWeight}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '使用单位：${CacheUtils.to.assertBindTaskInfo?.usedUnits}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '制造单位：${CacheUtils.to.assertBindTaskInfo?.manufactureUnits}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装模具使用模次：${CacheUtils.to.assertBindTaskInfo?.assetNo}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装模具寿命：${CacheUtils.to.assertBindTaskInfo?.assetLifespan}',
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
          height: 150,
        ),
        Obx(
          () => Container(
            padding: EdgeInsets.only(left: 16, right: 16),
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
                    Text('标签编号', style: textBoldNumberBlueStyle()),
                    Text(
                      '(${CacheUtils.to.assertBindTaskInfo?.lat ?? "0.0"}-${CacheUtils.to.assertBindTaskInfo?.lng ?? "0.0"})',
                      style: textNormalListTextStyle(),
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Divider(color: Colors.black26, height: 1)),
                Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(getLabels().toString(),
                        style: textNormalListTextStyle()))
              ],
            ),
          ),
        ),
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

  ///获取标签
  StringBuffer getLabels() {
    List<BindLabels> labels = CacheUtils.to.assertBindTaskInfo?.bindLabels;
    StringBuffer stringBuffer = StringBuffer();
    labels.forEach((element) {
      stringBuffer.writeln(element.labelNo);
    });
    return stringBuffer;
  }

  Widget ImageContain() {
    ///todo  测试使用
    const String testImage1 =
        'https://tse1-mm.cn.bing.net/th/id/OET.0b6df5a84be84e00ac0af44d644eb044?w=272&h=272&c=7&rs=1&o=5&dpr=1.25&pid=1.9';
    const String testImage2 =
        'https://tse1-mm.cn.bing.net/th/id/OET.62d14dc593b346259a456c0dd83bd8b6?w=272&h=272&c=7&rs=1&o=5&dpr=1.25&pid=1.9';
    const String testImage3 =
        'https://tse1-mm.cn.bing.net/th/id/OET.2567873a1fd04be7852a03de23158a00?w=272&h=272&c=7&rs=1&o=5&dpr=1.25&pid=1.9';

    List<BindLabels> labels = CacheUtils.to.assertBindTaskInfo?.bindLabels;

    ///标签类型 只显示 铭牌
    if (Get.arguments['taskType'] == MOULD_TASK_TYPE_LABEL.toString()) {
      if (labels.isNotEmpty) {
        return textImageWidget('铭牌照片', testImage1);
      } else {
        return Icon(Icons.hourglass_empty);
      }
    } else {
      /// 支付类型的  /// 支付类型 整体照片、铭牌照片、型腔照片
      return Column(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: textImageWidget('整体照片', testImage1)),
              Expanded(flex: 1, child: textImageWidget('铭牌照片', testImage2)),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: textImageWidget('型腔照片', testImage3)),
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
          Text(title, style: textNormalListTextStyle()),
          Image.network(imageUrl,
              height: SizeConstant.IAMGE_SIZE_HEIGHT,
              width: SizeConstant.IAMGE_SIZE_HEIGHT)
        ],
      ),
    );
  }
}
