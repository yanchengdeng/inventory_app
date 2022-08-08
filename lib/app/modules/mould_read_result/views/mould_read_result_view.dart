import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../../../entity/mould_bind.dart';
import '../../../routes/app_pages.dart';
import '../../../style/text_style.dart';
import '../../../utils/common.dart';
import '../../../values/constants.dart';
import '../../../values/size.dart';
import '../controllers/mould_read_result_controller.dart';
/**
 * 模具读取结果
 */

class MouldReadResultView extends GetView<MouldReadResultController> {
  @override
  Widget build(BuildContext context) {
    var taskNo = Get.arguments['taskNo'];
    var taskType = Get.arguments['taskType'];
    var assetNo = Get.arguments['assetNo'];

    ///任务类型  type  0为支付，1为标签替换
    Log.d("传递数据给读取编辑页：${taskNo}--${assetNo}----type=${taskType}");

    controller.getTaskInfo(taskNo, assetNo);

    return Scaffold(
      appBar: AppBar(
        title: Text('读取结果'),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () => {controller.saveInfo(taskNo)},
            child: Container(
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Text(
                '保存',
                style: textLitleBlackTextStyle(),
              ),
            ),
          ),
        ],
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
                      Text('固定资产编号：${controller.assertBindTaskInfo?.assetNo}',
                          style: textBoldNumberWhiteStyle()),
                      Text('SGM车型：${controller.assertBindTaskInfo?.vehicle}',
                          style: textLitleWhiteTextStyle()),
                      Text('零件号：${controller.assertBindTaskInfo?.moldNo}',
                          style: textLitleWhiteTextStyle()),
                      Text(
                          '工装&模具名称：${controller.assertBindTaskInfo?.toolingName}',
                          style: textLitleWhiteTextStyle()),
                      Obx(() => (Visibility(
                          visible: controller.isShowAllInfo.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '工装&模具尺寸(mm)：${controller.assertBindTaskInfo?.toolingSize}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装&模具重量(kg)：${controller.assertBindTaskInfo?.toolingWeight}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '使用单位：${controller.assertBindTaskInfo?.usedUnits}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '制造单位：${controller.assertBindTaskInfo?.manufactureUnits}',
                                  style: textLitleWhiteTextStyle()),
                              Text(
                                  '工装模具寿命：${controller.assertBindTaskInfo?.assetLifespan}',
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
        Obx(
          () => Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
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
                    InkWell(
                      child: Text(
                        getGpsInfo(),
                        style: textSmallTextStyle(),
                      ),
                      onTap: () => {controller.getGpsLagLng()},
                    ),
                    Spacer(flex: 1),
                    InkWell(
                      child: Obx(
                        () => Text(
                            controller.isRfidReadStatus.value
                                ? '切换为PDA扫描'
                                : '切换为RFID读取',
                            style: textNormalTextBlueStyle()),
                      ),
                      onTap: () => {
                        CommonUtils.showCommonDialog(
                            content: '切换后，页面数据将被清除?',
                            callback: () => {
                                  Get.back(),
                                  controller.clearData(),
                                  if (controller.isRfidReadStatus.value)
                                    {
                                      controller.getScanLabel(),
                                      controller.isRfidReadStatus.value = false,
                                    }
                                  else
                                    {
                                      // controller.startReadRfidData(),
                                      controller.isRfidReadStatus.value = true,
                                    }
                                })
                      },
                    )
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Divider(color: Colors.black26, height: 1)),
                Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(getLabels().toString(),
                        style: textNormalListTextStyle())),
                Obx(
                  () => Center(
                    child: Visibility(
                      visible: controller.isRfidReadStatus.value,
                      child: ElevatedButton(
                          onPressed: () => {controller.startReadRfidData()},
                          child: Text(
                              controller.isReadData.value ? '开始读取' : '结束读取')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.black12, thickness: 20.0),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
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
                  padding: EdgeInsets.only(bottom: 10), child: ImageContain())
            ],
          ),
        ),
      ],
    );
  }

  ///获取标签
  String getLabels() {
    List<BindLabels> labels = controller.assertBindTaskInfo?.bindLabels;
    StringBuffer stringBuffer = StringBuffer();
    labels?.forEach((element) {
      stringBuffer.writeln(element.labelNo);
    });
    if (stringBuffer.isEmpty) {
      return controller.readDataContent.value;
    } else {
      return stringBuffer.toString();
    }
  }

  Widget ImageContain() {
    /// 支付类型的  /// 支付类型 整体照片、铭牌照片、型腔照片
    /// 4.1资产图片分为整体照片、铭牌照片和型腔照片，每种类型上传一张，前两种照片需要在已读取标签前提下，识别到任一标签时才能拍照上传
    // 4.2模具类型为M必须上传全部三种照片，模具类型为F或G必须上传整体和铭牌照片。
    // 4.3图片只能现场拍照，上传后在右下角加上固定资产编号水印
    // 4.4当供应商读取标签并成功上传整体和铭牌照片，再将标签信息全部删除时，整体和铭牌照片也将被清空，删除最后一个标签前给予提示，“删除所有标签，将会清空已经上传的整体和铭牌照片，是否继续？”-确认/取消

    if (Get.arguments['taskType'] == MOULD_TASK_TYPE_LABEL.toString()) {
      return Container(
        margin: EdgeInsetsDirectional.only(top: 20, bottom: 30),
        child: Row(
          children: [
            Obx(() => InkWell(
                  child: Expanded(
                      flex: 1,
                      child: textImageWidget(
                          '铭牌照片',
                          controller.getNetImageUrl(
                              controller.imageUrlMp.value?.uriUuid ?? ""))),
                  onTap: () => {
                    Get.toNamed(Routes.TAKE_PHOTO,
                        arguments: {'photoType': PHOTO_TYPE_MP})
                  },
                )),
            Expanded(flex: 1, child: Text('')),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(top: 10, bottom: 10),
            child: Row(
              children: [
                Obx(() => InkWell(
                      child: Expanded(
                          flex: 1,
                          child: textImageWidget(
                              '整体照片',
                              controller.getNetImageUrl(
                                  controller.imageUrlAll.value?.uriUuid ??
                                      ""))),
                      onTap: () => {
                        if ((controller.gpsData.value).isEmpty)
                          {
                            controller.getGpsLagLng(),
                            toastInfo(msg: '获取定位中...')
                          }
                        else if ((controller.readDataContent.value).isEmpty)
                          {toastInfo(msg: "请先读取标签")}
                        else
                          {
                            Get.toNamed(Routes.TAKE_PHOTO,
                                arguments: {'photoType': PHOTO_TYPE_ALL})
                          }
                      },
                    )),
                Spacer(flex: 1),
                Obx(() => InkWell(
                      child: Expanded(
                          flex: 1,
                          child: textImageWidget(
                              '铭牌照片',
                              controller.getNetImageUrl(
                                  controller.imageUrlMp.value?.uriUuid ?? ""))),
                      onTap: () => {
                        Get.toNamed(Routes.TAKE_PHOTO,
                            arguments: {'photoType': PHOTO_TYPE_MP})
                      },
                    )),
              ],
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 20, bottom: 30),
            child: Row(
              children: [
                Obx(() => InkWell(
                      child: Expanded(
                          flex: 1,
                          child: textImageWidget(
                              '型腔照片',
                              controller.getNetImageUrl(
                                  controller.imageUrlXq.value?.uriUuid ?? ""))),
                      onTap: () => {
                        Get.toNamed(Routes.TAKE_PHOTO,
                            arguments: {'photoType': PHOTO_TYPE_XQ})
                      },
                    )),
                Expanded(flex: 1, child: Text('')),
              ],
            ),
          ),
        ],
      );
    }
  }

  ///文字 图片混合组件
  Widget textImageWidget(String title, String imageUrl) {
    return Container(
      width: SizeConstant.IAMGE_SIZE_HEIGHT,
      height: SizeConstant.IAMGE_SIZE_HEIGHT,
      child: Column(
        children: [
          Text(title, style: textNormalListTextStyle()),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.fromBorderSide(
                    BorderSide(color: Colors.black12, width: 2)),
                borderRadius:
                    BorderRadiusDirectional.all(Radius.circular(5.0))),
            child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.fitWidth,
                placeholder: (build, url) => Container(
                    alignment: AlignmentDirectional.center,
                    child: Icon(Icons.add_a_photo,
                        size: 80, color: Colors.black12)),
                errorWidget: (build, url, error) => Container(
                    alignment: AlignmentDirectional.center,
                    child: Icon(Icons.add_a_photo,
                        size: 80, color: Colors.black12)),
                height: SizeConstant.IAMGE_SIZE_HEIGHT,
                width: SizeConstant.IAMGE_SIZE_HEIGHT),
          )
        ],
      ),
    );
  }

  String getGpsInfo() {
    if (controller.assertBindTaskInfo?.lat != null) {
      return '(${controller.assertBindTaskInfo?.lat}-${controller.assertBindTaskInfo?.lng})';
    } else {
      return controller.gpsData.value ?? '0.00-0.00';
    }
  }
}
