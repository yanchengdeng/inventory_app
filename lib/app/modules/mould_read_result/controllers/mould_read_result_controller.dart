import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/ReadLabelInfo.dart';
import 'package:inventory_app/app/entity/UploadLabelParams.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';

import '../../../apis/file_api.dart';
import '../../../entity/LocationInfo.dart';
import '../../../entity/MouldBindTask.dart';
import '../../home/controllers/home_controller.dart';

class MouldReadResultController extends GetxController {
  ///是否显示全部
  var isShowAllInfo = false.obs;

  ///当前是否为rfid  否则为 二维码扫描 切换要清除前面数据 给弹框提示
  var isRfidReadStatus = true.obs;

  ///图片信息  全部照片
  var imageUrlAll = "".obs;

  ///铭牌照片
  var imageUrlMp = "".obs;

  ///型腔照片
  var imageUrlXq = "".obs;

  var locationInfo = LocationInfo().obs;

  ///读取rfid数据
  var isReadData = Rx<bool>(true);

  ///读取标签方式  0  两者  1  rfid  2 扫码
  var readLabelType = 0.obs;

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

  ///只初始化rfid
  // static const INIT_RFID_ONLY = 'init_rfid_and_only';

  ///只初始化扫描
  // static const INIT_SCAN_ONLY = 'init_scan_and_only';

  ///flutter 与android 原生交互  只能一次发送一个回复 模式
  static const platform = MethodChannel(READ_RFID_DATA_CHANNEL);

  ///模具资产信息
  var assertBindTaskInfo = MouldList().obs;

  final homeController = Get.find<HomeController>();

  /// 可以实现 android 低层持续向flutter 发送消息
  final _eventChannel = const EventChannel('event_channel_rfid');

  ///读取数据
  var readDataContent = ReadLabelInfo().obs;

  ///所有显示标签   已有标签+ 读取标签
  var showAllLabels = [].obs;

  ///开始读 、停止读
  startReadRfidData() async {
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
      }
    }
  }

  /// 获取经纬度
  getGpsLagLng() async {
    var latLng = await platform.invokeMethod(GET_GPS_LAT_LNG);
    Log.d("获取定位信息：$latLng");
    var location = jsonDecode(latLng);
    locationInfo.value = LocationInfo.fromJson(location);
  }

  @override
  void onInit() {
    super.onInit();

    _eventChannel.receiveBroadcastStream().listen((event) {
      var jsonLabels = jsonDecode(event);
      readDataContent.value = ReadLabelInfo.fromJson(jsonLabels);
      if (isRfidReadStatus.value) {
        if (readDataContent.value.type == LABEL_RFID) {
          readDataContent.value.data?.forEach((element) {
            if (!showAllLabels.contains(element)) {
              showAllLabels.add(element);
            }
          });
        } else {
          toastInfo(msg: '当前为RFID读取方式');
        }
      } else {
        if (readDataContent.value.type == LABEL_SCAN) {
          readDataContent.value.data?.forEach((element) {
            if (!showAllLabels.contains(element)) {
              showAllLabels.add(element);
            }
          });
        }
      }

      print("yancheng-返回到fullter 上标签数据：--${showAllLabels}");
    });
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

  void refreshImage(PhotoInfo uploadImageInfo) {
    if (uploadImageInfo.photoType == PHOTO_TYPE_ALL) {
      imageUrlAll.value = uploadImageInfo.fullPath ?? "";
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_MP) {
      imageUrlMp.value = uploadImageInfo.fullPath ?? "";
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_XQ) {
      imageUrlXq.value = uploadImageInfo.fullPath ?? "";
    }
  }

  ///获取编辑信息
  void getTaskInfo(taskNo, assetNo) async {
    ///
    // EasyLoading.show(status: "加载中...");
    // await FileApi.getFileToken();
    assertBindTaskInfo.value = homeController.mouldBindList.value.data
            ?.where((element) => element.taskNo == taskNo)
            ?.first
            ?.mouldList
            ?.where((element) => element.assetNo == assetNo)
            ?.first ??
        MouldList();

    ///默认添加已有标签
    assertBindTaskInfo.value.bindLabels?.forEach((element) {
      if (!showAllLabels.contains(element)) {
        showAllLabels.add(element);
      }
    });
    Log.d("读取页数据：${assertBindTaskInfo.value.toJson()}");
    if (assertBindTaskInfo.value.labelType == 0) {
      readLabelType.value = 0;
      isRfidReadStatus.value = true;
    } else if (assertBindTaskInfo.value.labelType == LABEL_RFID) {
      readLabelType.value = LABEL_RFID;
      isRfidReadStatus.value = true;
    } else if (assertBindTaskInfo.value.labelType == LABEL_SCAN) {
      readLabelType.value = LABEL_SCAN;
      isRfidReadStatus.value = false;
    }
    await platform.invokeMethod(INIT_RFID_AND_SCAN);
    EasyLoading.dismiss();
  }

  ///保存
  /**
   * 6.2标签是否在其它模具的标签信息中存在，如果重复，对重复模具进行提示，例：标签（XP000001）已被其他工装模具
   * （固定资产编号）绑定；标签（XP000002）已被其他工装模具（固定资产编号）绑定
   * 
   * 6.4.1支付任务类型+模具工装类型为M：标签编号至少有一个、整体照片、铭牌照片、型腔照片、存放位置经纬度
6.4.2支付任务类型+模具工装类型为F/G：标签编号至少有一个、整体照片、铭牌照片、存放位置经纬度
6.4.3标签替换任务类型：标签编号至少有一个、铭牌照片、存放位置经纬度
当模具绑定状态为“待上传”，对内容进行编辑后，以上内容有缺失时，保存后变为“待绑定/重新绑定
   */
  saveInfo(String taskType, String taskNo, String assertNo) async {
    if (showAllLabels.length == 0) {
      toastInfo(msg: "未做任何修改");
    } else {
      CommonUtils.showCommonDialog(
          content: "本模具已绑定${showAllLabels.length}个标签，是否确认？",
          callback: () {
            ///检查已读标签是否有和现有模具相同的标签
            var allLables = [];

            homeController.mouldBindList.value.data?.forEach((elementTask) {
              elementTask.mouldList?.forEach((element) {
                if (element.bindLabels?.isNotEmpty == true) {
                  element.bindLabels?.forEach((label) {
                    if (!allLables.contains(label)) {
                      allLables.add(label);
                    }
                  });
                }
              });
            });

            allLables.forEach((element) {
              if (showAllLabels.contains(element)) {
                toastInfo(msg: '标签（${element}）已被其他工装模具绑定');
              }
            });

            if (locationInfo.value.lat != null) {
              assertBindTaskInfo.value.lat = locationInfo.value.lat.toString();
              assertBindTaskInfo.value.lng = locationInfo.value.lng.toString();
              assertBindTaskInfo.value.address = locationInfo.value.address;
            }

            if (taskType == MOULD_TASK_TYPE_PAY.toString()) {
              if (imageUrlAll.isNotEmpty) {
                assertBindTaskInfo.value.overallPhoto?.fullPath =
                    imageUrlAll.value;
              }

              if (imageUrlMp.isNotEmpty) {
                assertBindTaskInfo.value.nameplatePhoto?.fullPath =
                    imageUrlMp.value;
              }

              if (imageUrlXq.isNotEmpty) {
                assertBindTaskInfo.value.cavityPhoto?.fullPath =
                    imageUrlXq.value;
              }
            } else {
              if (imageUrlMp.isNotEmpty) {
                assertBindTaskInfo.value.nameplatePhoto?.fullPath =
                    imageUrlMp.value;
              }
            }

            assertBindTaskInfo.value.bindLabels = showAllLabels.cast<String>();
            if (readDataContent.value.data != null &&
                readDataContent.value.data?.length != 0) {
              assertBindTaskInfo.value.labelType = readDataContent.value.type;
            }

            if (taskType == MOULD_TASK_TYPE_PAY.toString()) {
              if (assertBindTaskInfo.value.toolingType == TOOL_TYPE_M) {
                if (showAllLabels.length > 0 &&
                    assertBindTaskInfo
                            .value.nameplatePhoto?.fullPath?.isNotEmpty ==
                        true &&
                    assertBindTaskInfo
                            .value.cavityPhoto?.fullPath?.isNotEmpty ==
                        true &&
                    assertBindTaskInfo
                            .value.overallPhoto?.fullPath?.isNotEmpty ==
                        true &&
                    locationInfo.value.lat != null) {
                  assertBindTaskInfo.value.bindStatus =
                      BIND_STATUS_WAITING_UPLOAD;
                  assertBindTaskInfo.value.bindStatusText =
                      MOULD_BIND_STATUS[BIND_STATUS_WAITING_UPLOAD];
                }
              } else if (assertBindTaskInfo.value.toolingType == TOOL_TYPE_F ||
                  assertBindTaskInfo.value.toolingType == TOOL_TYPE_G) {
                if (showAllLabels.length > 0 &&
                    assertBindTaskInfo
                            .value.nameplatePhoto?.fullPath?.isNotEmpty ==
                        true &&
                    assertBindTaskInfo
                            .value.overallPhoto?.fullPath?.isNotEmpty ==
                        true &&
                    locationInfo.value.lat != null) {
                  assertBindTaskInfo.value.bindStatus =
                      BIND_STATUS_WAITING_UPLOAD;
                  assertBindTaskInfo.value.bindStatusText =
                      MOULD_BIND_STATUS[BIND_STATUS_WAITING_UPLOAD];
                }
              }
            } else {
              if (showAllLabels.length > 0 &&
                  assertBindTaskInfo
                          .value.nameplatePhoto?.fullPath?.isNotEmpty ==
                      true &&
                  locationInfo.value.lat != null) {
                assertBindTaskInfo.value.bindStatus =
                    BIND_STATUS_WAITING_UPLOAD;
                assertBindTaskInfo.value.bindStatusText =
                    MOULD_BIND_STATUS[BIND_STATUS_WAITING_UPLOAD];
              }
            }

            var st = homeController.mouldBindList.value.data
                ?.where((element) => element.taskNo == taskNo)
                ?.first
                .mouldList
                ?.where((element) => element.assetNo == assertNo)
                .first;
            st = assertBindTaskInfo.value;

            Log.d("最终结果：${st}");
            Log.d("最终结果：${homeController.mouldBindList}");
            CacheUtils.to
                .saveMouldTask(homeController.mouldBindList.value, true);
            toastInfo(msg: "保存成功");
            Get.back();

            ///弹出对话框
            Get.back();

            ///返回上一个页面
          });
    }
  }
}
