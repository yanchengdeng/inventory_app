import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../../../entity/InventoryData.dart';
import '../../../entity/LocationInfo.dart';
import '../../../entity/ReadLabelInfo.dart';
import '../../../utils/logger.dart';
import '../../home/controllers/home_controller.dart';

class InventoryTaskHandlerController extends GetxController {
  ///资产盘点搜索列表
  var _inventoryTaskHandle = RxList<InventoryDetail?>(List.empty());

  set inventoryTaskHandle(value) => _inventoryTaskHandle.value = value;

  get inventoryTaskHandle => _inventoryTaskHandle.value;

  final homeController = Get.find<HomeController>();

  var locationInfo = LocationInfo().obs;

  ///当前是否为rfid  否则为 二维码扫描   需求分开处理盘点   默认为true 即可
  var isRfidReadStatus = true.obs;

  ///读取rfid数据
  var isReadData = Rx<bool>(true);

  ///RFID SDK 通信channel  只允许上下行 一次交互
  static const String READ_RFID_DATA_CHANNEL = 'mould_read_result/blue_teeth';

  ///rfid 开始通过蓝牙获取信息
  static const String START_READ_RFID_DATA = 'startReadRfid';

  ///rfid 停止通过蓝牙获取信息
  static const String STOP_READ_RFID_DATA = 'stopReadRfidSdk';

  /// 获取gps经纬度
  static const String GET_GPS_LAT_LNG = 'getGpsLatLng';

  /// 初始化rfid sdk 和 扫描sdk
  static const String INIT_RFID_AND_SCAN = 'init_rfid_and_scan';

  /// 停止rfid sdk 和 扫描sdk
  static const String STOP_RFID_AND_SCAN = 'stop_rfid_and_scan';

  ///flutter 与android 原生交互  只能一次发送一个回复 模式
  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

  /// 可以实现 android 低层持续向flutter 发送消息
  final _eventChannel = const EventChannel('event_channel_rfid');

  ///读取数据
  var readDataContent = ReadLabelInfo().obs;

  ///所有显示标签   已有标签+ 读取标签
  var showAllLabels = [].obs;

  var taskNo = Get.arguments['taskNo'];

  ///查找查询数据
  findByParams(String taskNo) async {
    _inventoryTaskHandle.value = await homeController.inventoryList.value.data
            ?.where((element) => element.taskNo == taskNo)
            .first
            .list
            ?.where((element) =>
                element.assetInventoryStatus != INVENTORY_HAVE_UPLOADED &&
                checkHasSameLabel(element.labelNo))
            .toList() ??
        List.empty();
  }

/**
 * 需求是有一个标签相同则可
 * 检查盘点标签是否在rfid 读取标签中
 */
  bool checkHasSameLabel(String? labelNo) {
    if (labelNo != null && labelNo.isNotEmpty && showAllLabels.length > 0) {
      List<String> labels = labelNo.split(',');
      bool isSame = false;
      showAllLabels.forEach((element1) {
        labels.forEach((element2) {
          if (element1 == element2) {
            isSame = true;
          }
        });
      });

      return isSame;
    } else {
      return false;
    }
  }

  /**
 * 需求是有一个标签相同则可
 * 检查盘点标签是否在rfid 读取标签中
 */
  String getOneSameLable(String? labelNo) {
    List<String> labels = labelNo?.split(',') ?? List.empty();
    String sameLable = '';
    showAllLabels.forEach((element1) {
      labels.forEach((element2) {
        if (element1 == element2) {
          sameLable = element1;
        }
      });
    });

    return sameLable;
  }

  /// 获取经纬度
  getGpsLagLng() async {
    var latLng = await platform.invokeMethod(GET_GPS_LAT_LNG);
    Log.d("获取定位信息：$latLng");
    var location = jsonDecode(latLng);
    locationInfo.value = LocationInfo.fromJson(location);
    toastInfo(msg: '已成功定位');
  }

  ///开始读 、停止读
  startReadRfidData(String taskNo) async {
    if (isReadData.value) {
      var rfidDataFromAndroid =
          (await platform.invokeMethod(START_READ_RFID_DATA));
      if (rfidDataFromAndroid) {
        isReadData.value = false;
      }
    } else {
      var rfidDataFromAndroid =
          (await platform.invokeMethod(STOP_READ_RFID_DATA));
      if (rfidDataFromAndroid) {
        isReadData.value = true;
        findByParams(taskNo);
        getGpsLagLng();
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();

    _eventChannel.receiveBroadcastStream().listen((event) {
      var jsonLabels = jsonDecode(event);
      readDataContent.value = ReadLabelInfo.fromJson(jsonLabels);
      if (readDataContent.value.type == LABEL_RFID) {
        readDataContent.value.data?.forEach((element) {
          if (!showAllLabels.contains(element)) {
            showAllLabels.add(element);
          }
        });
      } else {
        ///扫描标签 先要定位
        if (locationInfo.value.address != null) {
          readDataContent.value.data?.forEach((element) {
            if (!showAllLabels.contains(element)) {
              showAllLabels.add(element);
            } else {
              toastInfo(msg: '');
            }
          });
          findByParams(taskNo);
        } else {
          getGpsLagLng();
        }
      }

      print("yancheng-返回到fullter 上标签数据：--${showAllLabels}");
    });

    isRfidReadStatus.value = Get.arguments['isRFID'];
    await platform.invokeMethod(INIT_RFID_AND_SCAN);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    ///需要做处理 关闭读取rfid 和扫描  读取生命周期维护放到android 生命周期中。目前为 app 退出或者 进程不存在会关闭
    // platform.invokeMethod(STOP_RFID_AND_SCAN);
    ///防止 离开页面没关闭rfid 读取
    await platform.invokeMethod(STOP_READ_RFID_DATA);
  }

  ///本地保存
  saveInfo(String taskNo) {
    if (_inventoryTaskHandle.isNotEmpty) {
      if (locationInfo.value.address?.isNotEmpty == true) {
        _inventoryTaskHandle.forEach((elementSearch) {
          var cacheAssertDetail = homeController.inventoryList.value.data
              ?.where((element) => element.taskNo == taskNo)
              .first
              .list
              ?.where((element) =>
                  element.assetInventoryDetailId ==
                  elementSearch?.assetInventoryDetailId)
              .first;
          cacheAssertDetail?.assetInventoryStatus = INVENTORY_WAITING_UPLOAD;
          cacheAssertDetail?.lat = locationInfo.value.lat;
          cacheAssertDetail?.lng = locationInfo.value.lng;
          cacheAssertDetail?.address = locationInfo.value.address;
        });
        CacheUtils.to
            .saveInventoryTask(homeController.inventoryList.value, true);
        toastInfo(msg: '保存成功');
        Get.back();
      } else {
        getGpsLagLng();
      }
    } else {
      toastInfo(msg: '暂无可盘点上传数据');
    }
  }
}
