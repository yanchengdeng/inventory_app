import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/services/services.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/values.dart';

import '../../../routes/app_pages.dart';
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

              ///测试图片地址： /data/user/0/com.luojie.erapp.inventory_app/cache/CAP518496658039260943.jpg
              onPressed: () => {Get.toNamed(Routes.TAKE_PHOTO)},
              child: Text('拍照')),
          ElevatedButton(
              onPressed: () => {controller.getGpsLagLng()},
              child: Text('获取经纬度')),
          Obx(() => Text('经纬度：${controller.gpsData.value}')),
          ElevatedButton(
              onPressed: () => {FileApi.getFileToken()},
              child: Text('获取文件token')),
          Image.file(
            File(
                '/data/user/0/com.luojie.erapp.inventory_app/cache/CAP518496658039260943.jpg'),
            height: 100,
            width: 100,
          ),
          ElevatedButton(
              onPressed: () => {
                    //     var formData = FormData.fromMap({
                    // 'name': 'wendux',
                    // 'age': 25,
                    // 'files': [
                    // await MultipartFile.fromFile('./text1.txt', filename: 'text1.txt'),
                    // await MultipartFile.fromFile('./text2.txt', filename: 'text2.txt'),
                    // ]
                    // });

                    FileApi.uploadFile({
                      'token': StorageService.to.getString(STORAGE_FILE_TOKEN),
                      "files": [
                        MultipartFile(
                            '/data/user/0/com.luojie.erapp.inventory_app/cache/CAP518496658039260943.jpg',
                            filename: 'CAP518496658039260943.jpg'),
                        MultipartFile(
                            '/data/user/0/com.luojie.erapp.inventory_app/cache/CAP8630163948010070952.jpg',
                            filename: 'CAP8630163948010070952.jpg')
                      ]
                    })
                  },
              child: Text('上传图片数据')),
        ],
      )),
    );
  }
}
