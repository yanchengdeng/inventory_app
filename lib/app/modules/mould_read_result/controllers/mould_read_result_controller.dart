import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../../../entity/cache_data.dart';
import '../../../entity/mould_bind.dart';
import '../../../services/storage.dart';
import '../../../utils/cache.dart';
import '../../../values/server.dart';
import '../../../values/storage.dart';

class MouldReadResultController extends GetxController {
  ///是否显示全部
  var isShowAllInfo = false.obs;

  ///当前是否为rfid  否则为 二维码扫描 切换要清除前面数据 给弹框提示
  var isRfidReadStatus = true.obs;

  ///rfid  或者 扫描读取数据
  var readDataContent = Rx<String>('');

  ///图片信息  全部照片
  var imageUrlAll = Rx<UploadImageInfo?>(null);

  ///铭牌照片
  var imageUrlMp = Rx<UploadImageInfo?>(null);

  ///型腔照片
  var imageUrlXq = Rx<UploadImageInfo?>(null);

  ///经纬度数据121.23312,1232.32
  var gpsData = Rx<String>('');

  ///读取rfid数据
  var isReadData = Rx<bool>(true);

  ///RFID SDK 通信channel
  static const String READ_RFID_DATA_CHANNEL = 'mould_read_result/blue_teeth';

  ///rfid 开始通过蓝牙获取信息
  static const String START_READ_RFID_DATA = 'startReadRfid';

  ///rfid 停止通过蓝牙获取信息
  static const String STOP_READ_RFID_DATA = 'stopReadRfidSdk';

  /// 获取gps经纬度
  static const String GET_GPS_LAT_LNG = 'getGpsLatLng';

  /// 获取扫描标签
  static const String GET_SCAN_LABEL = 'scan_label';

  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

  ///模具资产信息
  var _assertBindTaskInfo = Rx<MouldList?>(null);

  set assertBindTaskInfo(value) => _assertBindTaskInfo.value = value;

  get assertBindTaskInfo => _assertBindTaskInfo.value;

  ///开始读 、停止读
  startReadRfidData() async {
    if (isReadData.value) {
      var rfidDataFromAndroid =
          (await platform.invokeMethod(START_READ_RFID_DATA));
      readDataContent.value = rfidDataFromAndroid;
      isReadData.value = false;
    } else {
      isReadData.value = true;
      var rfidDataFromAndroid =
          (await platform.invokeMethod(STOP_READ_RFID_DATA));
      readDataContent.value = rfidDataFromAndroid;
    }
  }

  /// 获取经纬度
  getGpsLagLng() async {
    var latLng = await platform.invokeMethod(GET_GPS_LAT_LNG);
    gpsData.value = latLng;
  }

  /// 获取扫描label
  getScanLabel() async {
    var scanLabel = await platform.invokeMethod(GET_SCAN_LABEL) as String;
    readDataContent.value = scanLabel;
  }

  @override
  void onInit() {
    super.onInit();
    Log.d("MouldReadResultController--------onInit--");
  }

  @override
  void onReady() {
    super.onReady();
    Log.d("MouldReadResultController--------onReady--");
  }

  @override
  void onClose() {
    Log.d("MouldReadResultController--------onClose--");
  }

  void refreshImage(UploadImageInfo uploadImageInfo) {
    if (uploadImageInfo.photoType == PHOTO_TYPE_ALL) {
      imageUrlAll.value = uploadImageInfo;
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_MP) {
      imageUrlMp.value = uploadImageInfo;
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_XQ) {
      imageUrlXq.value = uploadImageInfo;
    }
  }

  ///获取网络图片展示地址
  String getNetImageUrl(String uriUuid) {
    return SERVER_FILE_UPLOAD +
        "/file/frontend/" +
        Uri.encodeComponent(uriUuid) +
        '?token=' +
        StorageService.to.getString(STORAGE_FILE_TOKEN) +
        "&mediaType=image";
  }

  ///清除页面信息  图片  标签
  clearData() {
    ///读取状态
    isReadData.value = true;

    ///扫描标签
    readDataContent.value = '';

    ///图片信息  全部照片
    imageUrlAll.value = null;

    ///铭牌照片
    imageUrlMp.value = null;

    ///型腔照片
    imageUrlXq.value = null;
  }

  void getTaskInfo(taskNo, assetNo) async {
    _assertBindTaskInfo.value =
        await CacheUtils.to.getUnLoadedAssetBindTaskInfo(taskNo, assetNo);
  }

  ///保存
  saveInfo(String taskNo) async {
    MouldData mouldData = CacheUtils.to.mouldBindTaskList;

    MouldList? mouldList = mouldData.unfinishedTaskList
        ?.where((element) => element.taskNo == taskNo)
        .first
        .mouldList
        ?.where((element) =>
            element.assetBindTaskId ==
            _assertBindTaskInfo.value?.assetBindTaskId)
        .first;

    BindLabels bindLabels = BindLabels();
    if (mouldList != null) {
      if (readDataContent.value.isNotEmpty) {
        if (mouldList.bindLabels?.isEmpty ?? true) {
          bindLabels.labelNo = readDataContent.value;
          mouldList.bindLabels?.add(bindLabels);
        }

        mouldList.bindLabels?[0].labelNo = readDataContent.value;
      }
      if (imageUrlAll.value != null) {
        if (mouldList.bindLabels?[0].overallPhoto == null) {
          mouldList.bindLabels?[0].overallPhoto = NameplatePhoto(
              downloadType: 'url', fullPath: imageUrlAll.value?.uriUuid);
        } else {
          mouldList.bindLabels?[0].overallPhoto?.downloadType = 'url';
          mouldList.bindLabels?[0].overallPhoto?.fullPath =
              imageUrlAll.value?.uriUuid;
        }
      }

      if (imageUrlMp.value != null) {
        if (mouldList.bindLabels?[0].nameplatePhoto == null) {
          mouldList.bindLabels?[0].nameplatePhoto = NameplatePhoto(
              downloadType: 'url', fullPath: imageUrlMp.value?.uriUuid);
        } else {
          mouldList.bindLabels?[0].nameplatePhoto?.downloadType = 'url';
          mouldList.bindLabels?[0].nameplatePhoto?.fullPath =
              imageUrlMp.value?.uriUuid;
        }
      }

      if (imageUrlXq.value != null) {
        if (mouldList.bindLabels?[0].cavityPhoto == null) {
          mouldList.bindLabels?[0].cavityPhoto = NameplatePhoto(
              downloadType: 'url', fullPath: imageUrlXq.value?.uriUuid);
        } else {
          mouldList.bindLabels?[0].cavityPhoto?.downloadType = 'url';
          mouldList.bindLabels?[0].cavityPhoto?.fullPath =
              imageUrlXq.value?.uriUuid;
        }
      }

      if (gpsData.value.isNotEmpty) {
        var latLng = gpsData.split(',');
        mouldList.lat = double.parse(latLng[0]);
        mouldList.lng = double.parse(latLng[1]);
      }
    }
    mouldList?.bindStatus = BIND_STATUS_WAITING_UPLOAD;

    CacheUtils.to.saveMouldTask(mouldData);
    toastInfo(msg: "保存成功");
    Get.back();
  }
}
