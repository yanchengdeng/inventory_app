import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/logger.dart';

import '../../../routes/app_pages.dart';
import '../../../services/storage.dart';
import '../../../values/server.dart';
import '../../../values/storage.dart';
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
    Log.d("传递数据给读取编辑页：${taskNo}--${assetNo}----type=${taskType}");

    // CacheUtils.to.getUnLoadedAssetBindTaskInfo(taskNo, assetNo);

    return Scaffold(
      appBar: AppBar(
        title: Text('读取结果'),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () => {Get.toNamed(Routes.TAKE_PHOTO)},
              child: Text('拍照上传')),
          ElevatedButton(
              onPressed: () => {controller.getGpsLagLng()},
              child: Text('获取经纬度')),
          Obx(() => Text('经纬度：${controller.gpsData.value}')),
          Obx(() => Column(
                children: [
                  Text('拍照结果：${controller.imageUrl.value?.uriUuid}'),
                  Text('拍照路径：${controller.imageUrl.value?.filePath}'),
                  Text('拍照名称：${controller.imageUrl.value?.fileName}'),
                  Text(
                      '显示图片地址：${SERVER_FILE_UPLOAD}/file/backend/${Uri.encodeComponent(controller.imageUrl.value?.uriUuid ?? "")}?token=' +
                          StorageService.to.getString(STORAGE_FILE_TOKEN)),
                  Image.network(
                    SERVER_FILE_UPLOAD +
                        "/file/backend/" +
                        Uri.encodeComponent(
                            controller.imageUrl.value?.uriUuid ?? "") +
                        '?token=' +
                        StorageService.to.getString(STORAGE_FILE_TOKEN),
                    height: 100,
                    width: 100,
                  )
                ],
              )),
          ElevatedButton(
              onPressed: () => {controller.initRfidData()},
              child: Text('连接设备')),
          ElevatedButton(
              onPressed: () => {controller.startReadRfidData()},
              child: Text(controller.isReadData.value ? '读取' : '结束')),
          ElevatedButton(
              onPressed: () => {controller.getScanLabel()},
              child: Text('扫描标签')),
          Obx(() => Text('标签数据：${controller.scanLabelData.value}'))
        ],
      )),
    );
  }
}
