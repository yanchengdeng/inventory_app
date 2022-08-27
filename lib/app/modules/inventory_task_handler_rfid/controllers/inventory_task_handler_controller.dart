import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/routes/app_pages.dart';
import 'package:inventory_app/app/services/services.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../../../apis/inventory_api.dart';
import '../../../entity/InventoryData.dart';
import '../../../entity/LocationInfo.dart';
import '../../../entity/ReadLabelInfo.dart';
import '../../../services/location.dart';
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

  ///读取rfid 标题状态展示
  var readRFIDTitle = '读取盘点'.obs;

  ///RFID SDK 通信channel  只允许上下行 一次交互
  static const String READ_RFID_DATA_CHANNEL = 'mould_read_result/blue_teeth';

  ///rfid 开始通过蓝牙获取信息
  static const String START_READ_RFID_DATA = 'startReadRfid';

  ///rfid 停止通过蓝牙获取信息
  static const String STOP_READ_RFID_DATA = 'stopReadRfidSdk';

  ///初始化rfid 和扫描
  static const String INIT_RFID_AND_SCAN = 'init_rfid_and_scan';

  ///释放rfid 和 扫描
  static const String RELEASE_SCAN_AND_RFID = 'release_scan_and_rfid';

  /// 检查定位权限
  static const String CHECK_LOCATION_PERMISSION = 'check_location_permission';

  /// 初始化rfid sdk 和 扫描sdk
  // static const String INIT_RFID_AND_SCAN = 'init_rfid_and_scan';

  /// 停止rfid sdk 和 扫描sdk
  // static const String STOP_RFID_AND_SCAN = 'stop_rfid_and_scan';

  /// 初始化rfid sdk 和 扫描sdk
  // static const String INIT_RFID_AND_SCAN = 'init_rfid_and_scan';

  /// 停止rfid sdk 和 扫描sdk
  // static const String STOP_RFID_AND_SCAN = 'stop_rfid_and_scan';

  ///flutter 与android 原生交互  只能一次发送一个回复 模式
  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

  /// 可以实现 android 低层持续向flutter 发送消息
  final _eventChannel = const EventChannel('event_channel_rfid');

  ///读取数据
  var readDataContent = ReadLabelInfo().obs;

  ///所有显示标签   已有标签+ 读取标签
  var showAllLabels = [].obs;

  var taskNo = Get.arguments['taskNo'];

  /// 标记上传的次数
  var markUploadCount = 0;

  ///定时器 如果是rfid 读取则一分钟后停止
  var rfidReadTime = const Duration(seconds: 10);
  Timer? timer = null;

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

    _inventoryTaskHandle.forEach((element) {
      Log.d("找到数据${element?.toJson().toString()}");
    });
  }

/**
 * 需求是有一个标签相同则可
 * 检查盘点标签是否在rfid 读取标签中
 */
  bool checkHasSameLabel(String? labelNo) {
    if (labelNo != null && labelNo.isNotEmpty && showAllLabels.length > 0) {
      List<String> labels = [];
      if (labelNo.contains(',')) {
        labels = labelNo.split(',');
      } else {
        labels = [labelNo];
      }
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
    if (await CommonUtils.isConnectNet()) {
      if (await platform.invokeMethod(CHECK_LOCATION_PERMISSION)) {
        toastInfo(msg: '定位中...');
        LocationMapService.to.initMap();
        LocationMapService.to.startLocation();
      } else {
        Log.d('定位授权');
      }
    } else {
      toastInfo(msg: '请检查网络');
    }
  }

  ///开始读 、停止读
  startReadRfidData(String taskNo) {
    if (isReadData.value) {
      startReadRFID();
    } else {
      stopReadRFID();
    }
  }

  ///开始rfid 读取
  void startReadRFID() async {
    var rfidDataFromAndroid =
        (await platform.invokeMethod(START_READ_RFID_DATA));
    if (rfidDataFromAndroid) {
      isReadData.value = false;
      readRFIDTitle.value = '读取中';
      timer = Timer(rfidReadTime, () {
        Log.d('倒计时结束了');
        stopReadRFID();
      });
    }
  }

  /// 停止读取rfid
  void stopReadRFID() async {
    var rfidDataFromAndroid =
        (await platform.invokeMethod(STOP_READ_RFID_DATA));
    if (rfidDataFromAndroid) {
      isReadData.value = true;
      readRFIDTitle.value = '读取完成';
      timer?.cancel();
      findByParams(taskNo);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    isRfidReadStatus.value = Get.arguments['isRFID'];
    readRFIDTitle.value = isRfidReadStatus.value ? '读取盘点' : '扫描清单';
    _eventChannel.receiveBroadcastStream().listen((event) {
      var jsonLabels = jsonDecode(event);
      readDataContent.value = ReadLabelInfo.fromJson(jsonLabels);
      if (readDataContent.value.type == LABEL_RFID && isRfidReadStatus.value) {
        readDataContent.value.data?.forEach((element) {
          if (!showAllLabels.contains(element)) {
            showAllLabels.add(element);
          }
        });
        findByParams(taskNo);
      } else {
        ///扫描标签 先要定位
        if (LocationMapService.to.locationResult.value.address != null &&
            readDataContent.value.type == LABEL_SCAN) {
          locationInfo.value = LocationMapService.to.locationResult.value;
          if (!isRfidReadStatus.value) {
            readDataContent.value.data?.forEach((element) {
              if (!showAllLabels.contains(element)) {
                showAllLabels.add(element);
              } else {
                toastInfo(msg: '已扫描过该标签');
              }
            });
            findByParams(taskNo);
          } else {
            toastInfo(msg: '当前盘点方式为读取盘点');
          }
        } else {
          getGpsLagLng();
        }
      }

      print("yancheng-返回到fullter 上标签数据：--${showAllLabels}");
    });

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
    // platform.invokeMethod(STOP_RFID_AND_SCAN);
    ///防止 离开页面没关闭rfid 读取
    LocationMapService.to.stopLocation();
    await platform.invokeMethod(RELEASE_SCAN_AND_RFID);
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
      // toastInfo(msg: '暂无可保存数据');
    }
  }

  ///上传盘点任务
  void upload() async {
    if (_inventoryTaskHandle.isNotEmpty) {
      EasyLoading.show(status: '上传中...');
      _inventoryTaskHandle
          .forEach((element) => {uploadSingleInventory(element)});
    } else {
      toastInfo(msg: '当前无待上传状态的模具可上传');
    }
  }

/**
 * 根据盘点详情id上传盘点数据，特别的，如果message返回-1和-2需要做APP端做特殊处理。
 * -1：模具所在的盘点单是否需要盘点，如果不需要此供应商盘点，列表页也不再加载此盘点单，从缓存中删除，并提示：xxxx（盘点编号）已从任务中移除模具所在的盘点单是否已经取消，
 * -2：如果盘点状态为已取消，列表页也不再加载此盘点单，从缓存中删除，
 * 提示：xxxx（盘点编号）已从任务中移除。其中xxxx，需要把盘点列表的inventoryTaskId一路带到上传界面，以支持此场景
 */
  ///单个盘点任务上传
  void uploadSingleInventory(InventoryDetail? element) async {
    if (element?.labelNo?.isEmpty == true) {
      toastInfo(msg: '该数据无任何标签');
      return;
    }
    var jsonMaps = HashMap();
    jsonMaps['address'] = locationInfo.value.address;
    jsonMaps['bindLabel'] = element?.labelNo?.split(',')[0];
    jsonMaps['inventoryDetailId'] = element?.assetInventoryDetailId;
    jsonMaps['lat'] = locationInfo.value.lat;
    jsonMaps['lng'] = locationInfo.value.lng;

    int resultCode =
        await InventoryApi.uploadInventoryTask(jsonEncode(jsonMaps));
    markUploadCount++;
    if (resultCode == API_RESPONSE_OK) {
      element?.assetInventoryStatus = INVENTORY_HAVE_UPLOADED;

      List<InventoryDetail?>? allFinished = homeController
          .inventoryList.value.data
          ?.where((elementItem) => elementItem.taskNo == this.taskNo)
          .first
          .list
          ?.where((element2) =>
              element2.assetInventoryStatus == INVENTORY_HAVE_UPLOADED)
          .toList();
      Log.d(
          "绑定任务都已上传 ，现在${homeController.inventoryList.value.data?.length}个任务");
      if (homeController.inventoryList.value.data
              ?.where((elementItem) => elementItem.taskNo == this.taskNo)
              .first
              .list
              ?.length ==
          allFinished?.length) {
        ///已完成和总数形同则删除该任务

        homeController.inventoryList.value.data
            ?.removeWhere((element) => element.taskNo == this.taskNo);

        Log.e(
            "该任务下都已经上传 ，删除该模具任务现在还有${homeController.inventoryList.value.data?.length}个任务");

        if (homeController.inventoryList.value.data?.length == 0) {
          homeController.inventoryList.value = InventoryData();
        }

        await CacheUtils.to
            .saveInventoryTask(homeController.inventoryList.value, true);

        ///直接返回第一级列表：
        Get.until((route) => Get.currentRoute == Routes.INVENTORY_TASKLIST);
      } else {
        if (markUploadCount == _inventoryTaskHandle.length) {
          Get.back();
        }
      }
    } else if (resultCode == -1) {
      toastInfo(msg: '${element?.assetNo}已从任务中移除模具所在的盘点单');
      homeController.inventoryList.value.data
          ?.where((element) => element.taskNo == this.taskNo)
          .first
          .list
          ?.removeWhere((element1) => element1.assetNo == element?.assetNo);

      CacheUtils.to.saveInventoryTask(homeController.inventoryList.value, true);
      if (markUploadCount == _inventoryTaskHandle.length) {
        Get.back();
      }
    } else if (resultCode == -2) {
      toastInfo(msg: '${element?.assetNo}已从任务中移除模具所在的盘点单');

      homeController.inventoryList.value.data
          ?.where((element) => element.taskNo == this.taskNo)
          .first
          .list
          ?.removeWhere((element1) => element1.assetNo == element?.assetNo);

      CacheUtils.to.saveInventoryTask(homeController.inventoryList.value, true);
      if (markUploadCount == _inventoryTaskHandle.length) {
        Get.back();
      }
    }
  }
}
