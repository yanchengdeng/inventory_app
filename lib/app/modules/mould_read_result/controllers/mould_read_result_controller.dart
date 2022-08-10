import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/apis/apis.dart';
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
      if (_assertBindTaskInfo.value?.bindLabels?.isEmpty ?? true) {
        _assertBindTaskInfo.value?.bindLabels?.add(BindLabels());
      }
      _assertBindTaskInfo.value?.bindLabels?[0].labelNo = readDataContent.value;
    } else {
      isReadData.value = true;
      var rfidDataFromAndroid =
          (await platform.invokeMethod(STOP_READ_RFID_DATA));
      readDataContent.value = rfidDataFromAndroid;
      if (_assertBindTaskInfo.value?.bindLabels?.isEmpty ?? true) {
        _assertBindTaskInfo.value?.bindLabels?.add(BindLabels());
      }
      _assertBindTaskInfo.value?.bindLabels?[0].labelNo = readDataContent.value;
    }
  }

  /// 获取经纬度
  getGpsLagLng() async {
    var latLng = await platform.invokeMethod(GET_GPS_LAT_LNG);
    gpsData.value = latLng;
    if (_assertBindTaskInfo.value?.bindLabels?.isEmpty ?? true) {
      _assertBindTaskInfo.value?.bindLabels?.add(BindLabels());
    }
    _assertBindTaskInfo.value?.lat = double.parse(gpsData.value.split(',')[0]);
    _assertBindTaskInfo.value?.lng = double.parse(gpsData.value.split(',')[1]);
  }

  /// 获取扫描label
  getScanLabel() async {
    var scanLabel = await platform.invokeMethod(GET_SCAN_LABEL) as String;
    readDataContent.value = scanLabel;
    if (_assertBindTaskInfo.value?.bindLabels?.isEmpty ?? true) {
      _assertBindTaskInfo.value?.bindLabels?.add(BindLabels());
    }
    _assertBindTaskInfo.value?.bindLabels?[0].labelNo = readDataContent.value;
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

    ///需要做处理 关闭读取rfid
    if (!isReadData.value) {
      //正在读 则需要关闭
      platform.invokeMethod(STOP_READ_RFID_DATA);
    }
  }

  void refreshImage(UploadImageInfo uploadImageInfo) {
    MouldList? mouldList = _assertBindTaskInfo.value;
    if (_assertBindTaskInfo.value?.bindLabels?.isEmpty ?? true) {
      _assertBindTaskInfo.value?.bindLabels?.add(BindLabels());
    }
    if (uploadImageInfo.photoType == PHOTO_TYPE_ALL) {
      if (_assertBindTaskInfo.value?.bindLabels?[0].overallPhoto == null) {
        _assertBindTaskInfo.value?.bindLabels?[0].overallPhoto =
            NameplatePhoto();
      }
      imageUrlAll.value = uploadImageInfo;
      mouldList?.bindLabels?[0].overallPhoto?.fullPath =
          uploadImageInfo.filePath;
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_MP) {
      if (_assertBindTaskInfo.value?.bindLabels?[0].nameplatePhoto == null) {
        _assertBindTaskInfo.value?.bindLabels?[0].nameplatePhoto =
            NameplatePhoto();
      }
      imageUrlMp.value = uploadImageInfo;
      mouldList?.bindLabels?[0].nameplatePhoto?.fullPath =
          uploadImageInfo.filePath;
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_XQ) {
      if (_assertBindTaskInfo.value?.bindLabels?[0].cavityPhoto == null) {
        _assertBindTaskInfo.value?.bindLabels?[0].cavityPhoto =
            NameplatePhoto();
      }
      imageUrlXq.value = uploadImageInfo;
      mouldList?.bindLabels?[0].cavityPhoto?.fullPath =
          uploadImageInfo.filePath;
    }
    _assertBindTaskInfo.value = mouldList;
  }

  ///清除页面信息  图片  标签
  clearData() {
    ///读取状态
    isReadData.value = true;

    ///扫描标签
    readDataContent.value = '';
  }

  void getTaskInfo(taskNo, assetNo) async {
    await FileApi.getFileToken();
    _assertBindTaskInfo.value =
        await CacheUtils.to.getUnLoadedAssetBindTaskInfo(taskNo, assetNo);
    if (_assertBindTaskInfo.value?.bindLabels != null) {
      if (_assertBindTaskInfo.value?.bindLabels?[0].nameplatePhoto != null) {
        imageUrlMp.value = UploadImageInfo(
            filePath: _assertBindTaskInfo
                .value?.bindLabels?[0].nameplatePhoto?.fullPath);
      }

      if (_assertBindTaskInfo.value?.bindLabels?[0].cavityPhoto != null) {
        imageUrlXq.value = UploadImageInfo(
            filePath: _assertBindTaskInfo
                .value?.bindLabels?[0].cavityPhoto?.fullPath);
      }

      if (_assertBindTaskInfo.value?.bindLabels?[0].overallPhoto != null) {
        imageUrlAll.value = UploadImageInfo(
            filePath: _assertBindTaskInfo
                .value?.bindLabels?[0].overallPhoto?.fullPath);
      }

      gpsData.value =
          '${_assertBindTaskInfo.value?.lat},${_assertBindTaskInfo.value?.lng}';

      readDataContent.value =
          _assertBindTaskInfo.value?.bindLabels?[0].labelNo ?? '';
    }
  }

  ///保存
  saveInfo(String taskType, String taskNo) async {
    MouldData mouldData = CacheUtils.to.mouldBindTaskList;

    MouldList? mouldList = null;

    if (taskType == MOULD_TASK_TYPE_PAY.toString()) {
      mouldList = mouldData.unfinishedTaskList
          ?.where((element) => element.taskNo == taskNo)
          .first
          .mouldList
          ?.where((element) =>
              element.assetBindTaskId ==
              _assertBindTaskInfo.value?.assetBindTaskId)
          .first;
    } else {
      mouldList = mouldData.unfinishedTaskList
          ?.where((element) => element.taskNo == taskNo)
          .first
          .mouldList
          ?.where((element) =>
              element.labelReplaceTaskId ==
              _assertBindTaskInfo.value?.labelReplaceTaskId)
          .first;
    }

    if (mouldList != null) {
      if (taskType == MOULD_TASK_TYPE_PAY.toString() &&
          mouldList.toolingType == TOOL_TYPE_M) {
        if (mouldList.bindLabels?[0].cavityPhoto != null &&
            mouldList.bindLabels?[0].nameplatePhoto != null &&
            mouldList.bindLabels?[0].overallPhoto != null) {
          mouldList.bindStatus = BIND_STATUS_WAITING_UPLOAD;
        } else {
          mouldList.bindStatus = BIND_STATUS_REBIND;
        }
      } else if (taskType == MOULD_TASK_TYPE_PAY.toString() &&
          mouldList.toolingType == TOOL_TYPE_G) {
        if (mouldList.bindLabels?[0].nameplatePhoto != null &&
            mouldList.bindLabels?[0].overallPhoto != null) {
          mouldList.bindStatus = BIND_STATUS_WAITING_UPLOAD;
        } else {
          mouldList.bindStatus = BIND_STATUS_REBIND;
        }
      } else if (taskType == MOULD_TASK_TYPE_LABEL.toString()) {
        if (mouldList.bindLabels?[0].nameplatePhoto != null) {
          mouldList.bindStatus = BIND_STATUS_WAITING_UPLOAD;
        } else {
          mouldList.bindStatus = BIND_STATUS_REBIND;
        }
      } else {
        mouldList.bindStatus = BIND_STATUS_REBIND;
      }
    }

    mouldList?.lat = _assertBindTaskInfo.value?.lat;
    mouldList?.lng = _assertBindTaskInfo.value?.lng;
    mouldList?.bindLabels?[0].labelNo = readDataContent.value;

    // mouldList = _assertBindTaskInfo.value;

    CacheUtils.to.saveMouldTask(mouldData, true);
    toastInfo(msg: "保存成功");
    Get.back();
  }
}
