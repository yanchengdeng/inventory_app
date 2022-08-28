import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/entity/ReadLabelInfo.dart';
import 'package:inventory_app/app/entity/UploadLabelParams.dart';
import 'package:inventory_app/app/services/location.dart';
import 'package:inventory_app/app/utils/cache.dart';
import 'package:inventory_app/app/utils/common.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/values/constants.dart';
import 'package:inventory_app/app/widgets/toast.dart';
import '../../../apis/file_api.dart';
import '../../../entity/MouldBindTask.dart';
import '../../../utils/callback.dart';
import '../../../utils/loading.dart';
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

  // var locationInfo = LocationInfo().obs;

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

  ///拍照前读取的标签  ： 目的和已有标签对比，如果有一个相同则可以拍照保存
  List<String> vertifyLables = [];

  ///是否是验证标签状态
  var isVertifyLable = false.obs;

  ///任务类型
  var taskType = MOULD_TASK_TYPE_PAY;

  ///开始读 、停止读
  startReadRfidData() {
    isVertifyLable.value = false;
    if (isReadData.value) {
      startReadRFID();
    } else {
      stopReadRFID();
    }
  }

  ///拍照前验证标签使用  倒计时5秒如果没有找到标签取的标签则提示 请在标签附近拍照上传照片
  startReadRFIDForTakePhoto(VertifyLableCallback callback) async {
    isVertifyLable.value = true;
    var rfidDataFromAndroid =
        (await platform.invokeMethod(START_READ_RFID_DATA));

    if (rfidDataFromAndroid) {
      Loading.show('读取标签中');
      var isOk = false;
      Timer(
          Duration(seconds: 5),
          () => {
                Loading.dismiss(),
                stopReadRFID(),
                showAllLabels.forEach((elementLabel) {
                  vertifyLables.forEach((elementVertify) {
                    if (elementLabel == elementVertify) {
                      isOk = true;
                    }
                  });
                }),
                callback(isOk)
              });
    }
  }

  startReadRFID() async {
    var rfidDataFromAndroid =
        (await platform.invokeMethod(START_READ_RFID_DATA));
    if (rfidDataFromAndroid) {
      isReadData.value = false;
    }
  }

  stopReadRFID() async {
    var rfidDataFromAndroid =
        (await platform.invokeMethod(STOP_READ_RFID_DATA));
    if (rfidDataFromAndroid) {
      isReadData.value = true;
    }
  }

  /// 获取经纬度 实在拍照片后获取 如果获取失败则照片也删除
  getGpsLagLng(int pthotoType) async {
    if (await CommonUtils.isConnectNet()) {
      if (await platform.invokeMethod(CHECK_LOCATION_PERMISSION)) {
        toastInfo(msg: '定位中...');
        LocationMapService.to.initMap();
        LocationMapService.to.startLocation();
        Timer.periodic(Duration(seconds: 2), (timer) {
          Log.d(
              "定位数据更新：${LocationMapService.to.locationResult.value.toJson()}");
          if (LocationMapService.to.locationResult.value.address != null) {
            assertBindTaskInfo.value.address =
                LocationMapService.to.locationResult.value.address;
            assertBindTaskInfo.value.lat =
                LocationMapService.to.locationResult.value.lat?.toString();
            assertBindTaskInfo.value.lng =
                LocationMapService.to.locationResult.value.lng?.toString();

            ///验证标签状态已结束，恢复为初始状态
            isVertifyLable.value = false;
            assertBindTaskInfo.refresh();

            timer.cancel();
          }
        });
      } else {
        Log.d('定位授权');
      }
    } else {
      toastInfo(msg: "请检查网络");
      if (pthotoType == PHOTO_TYPE_ALL) {
        ///todo 删除图片
        // await File(imageUrlAll.value).delete();
        imageUrlAll.value = '';
      } else if (pthotoType == PHOTO_TYPE_MP) {
        // await File(imageUrlMp.value).delete();
        imageUrlMp.value = '';
      }
    }
  }

  ///清空经纬度信息
  ///场景： 全部删除标签   ； 支付类型删除整体照片  ；标签类型删除铭牌照片
  clearGPS() {
    assertBindTaskInfo.value.address = null;
    assertBindTaskInfo.value.lat = '';
    assertBindTaskInfo.value.lng = '';
    LocationMapService.to.stopLocation();
    assertBindTaskInfo.refresh();
  }

  @override
  void onInit() async {
    super.onInit();

    _eventChannel.receiveBroadcastStream().listen((event) {
      var jsonLabels = jsonDecode(event);
      readDataContent.value = ReadLabelInfo.fromJson(jsonLabels);
      Log.d("RFID、扫码真实返回标签：${jsonLabels}");
      if (isVertifyLable.value) {
        vertifyLables = readDataContent.value.data ?? List.empty();
      } else {
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
    LocationMapService.to.stopLocation();
    await platform.invokeMethod(RELEASE_SCAN_AND_RFID);
  }

  void refreshImage(PhotoInfo uploadImageInfo) {
    if (uploadImageInfo.photoType == PHOTO_TYPE_ALL) {
      imageUrlAll.value = uploadImageInfo.fullPath ?? "";
      getGpsLagLng(uploadImageInfo.photoType ?? PHOTO_TYPE_ALL);
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_MP) {
      imageUrlMp.value = uploadImageInfo.fullPath ?? "";
      if (taskType == MOULD_TASK_TYPE_LABEL) {
        getGpsLagLng(uploadImageInfo.photoType ?? MOULD_TASK_TYPE_LABEL);
      }
    } else if (uploadImageInfo.photoType == PHOTO_TYPE_XQ) {
      imageUrlXq.value = uploadImageInfo.fullPath ?? "";
    }
  }

  ///获取编辑信息
  void getTaskInfo(String taskNo, int taskType, int bindId) async {
    this.taskType = taskType;

    ///
    // EasyLoading.show(status: "加载中...");
    if (await CommonUtils.isConnectNet()) {
      EasyLoading.show(status: "加载中...");
      await FileApi.getFileToken();
    }
    assertBindTaskInfo.value = homeController.mouldBindList.value.data
            ?.where((elementTask) =>
                elementTask.taskNo == taskNo &&
                taskType == elementTask.taskType)
            .first
            .mouldList
            ?.where((element) => taskType == MOULD_TASK_TYPE_PAY
                ? element.assetBindTaskId == bindId
                : element.labelReplaceTaskId == bindId)
            .first ??
        MouldList();

    ///默认添加已有标签
    assertBindTaskInfo.value.bindLabels?.forEach((element) {
      if (!showAllLabels.contains(element)) {
        showAllLabels.add(element);
      }
    });

    ///照片显示
    imageUrlAll.value = assertBindTaskInfo.value.overallPhoto?.fullPath ?? '';
    imageUrlMp.value = assertBindTaskInfo.value.nameplatePhoto?.fullPath ?? '';
    imageUrlXq.value = assertBindTaskInfo.value.cavityPhoto?.fullPath ?? '';

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
  saveInfo(String taskNo, int taskType, int bindId) async {
    ///检查已读标签是否有和现有模具相同的标签
    var allLables = [];

    ///是否本地缓存数据存在已读标签
    var isExistSameLable = false;

    ///所有标签  [过滤掉当前任务的]
    homeController.mouldBindList.value.data?.forEach((elementTask) {
      elementTask.mouldList?.forEach((element) {
        if (element.bindLabels?.isNotEmpty == true) {
          element.bindLabels?.forEach((label) {
            if (!allLables.contains(label) &&
                !(taskType == MOULD_TASK_TYPE_PAY
                    ? element.assetBindTaskId == bindId
                    : element.labelReplaceTaskId == bindId)) {
              allLables.add(label);
            }
          });
        }
      });
    });

    allLables.forEach((element) {
      if (showAllLabels.contains(element)) {
        isExistSameLable = true;
      }
    });

    if (isExistSameLable) {
      allLables.forEach((element) {
        if (showAllLabels.contains(element)) {
          toastInfo(msg: '标签（${element}）已被其他工装模具绑定');
        }
      });
      return;
    } else {
      CommonUtils.showCommonDialog(
          content: "本模具已绑定${showAllLabels.length}个标签，是否确认？",
          callback: () {
            if (taskType == MOULD_TASK_TYPE_PAY) {
              if (imageUrlAll.isNotEmpty) {
                assertBindTaskInfo.value.overallPhoto?.fullPath =
                    imageUrlAll.value;
              } else {
                assertBindTaskInfo.value.overallPhoto?.fullPath = '';
              }

              if (imageUrlMp.isNotEmpty) {
                assertBindTaskInfo.value.nameplatePhoto?.fullPath =
                    imageUrlMp.value;
              } else {
                assertBindTaskInfo.value.nameplatePhoto?.fullPath = '';
              }

              if (imageUrlXq.isNotEmpty) {
                assertBindTaskInfo.value.cavityPhoto?.fullPath =
                    imageUrlXq.value;
              } else {
                assertBindTaskInfo.value.cavityPhoto?.fullPath = '';
              }
            } else {
              if (imageUrlMp.isNotEmpty) {
                assertBindTaskInfo.value.nameplatePhoto?.fullPath =
                    imageUrlMp.value;
              } else {
                assertBindTaskInfo.value.nameplatePhoto?.fullPath = '';
              }
            }

            assertBindTaskInfo.value.bindLabels = showAllLabels.cast<String>();
            if (readDataContent.value.data != null &&
                readDataContent.value.data?.length != 0) {
              assertBindTaskInfo.value.labelType = readDataContent.value.type;
            }
            if (showAllLabels.isEmpty) {
              ///没标签 则标签类型 恢复至默认状态
              assertBindTaskInfo.value.labelType =
                  assertBindTaskInfo.value.labelTypePre;
            }

            if (taskType == MOULD_TASK_TYPE_PAY) {
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
                    assertBindTaskInfo.value.address != null) {
                  assertBindTaskInfo.value.bindStatus =
                      BIND_STATUS_WAITING_UPLOAD;
                  assertBindTaskInfo.value.bindStatusText =
                      MOULD_BIND_STATUS[BIND_STATUS_WAITING_UPLOAD];
                } else {
                  assertBindTaskInfo.value.bindStatus =
                      assertBindTaskInfo.value.bindStatusPre;
                  assertBindTaskInfo.value.bindStatusText =
                      MOULD_BIND_STATUS[assertBindTaskInfo.value.bindStatusPre];
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
                    assertBindTaskInfo.value.address != null) {
                  assertBindTaskInfo.value.bindStatus =
                      BIND_STATUS_WAITING_UPLOAD;
                  assertBindTaskInfo.value.bindStatusText =
                      MOULD_BIND_STATUS[BIND_STATUS_WAITING_UPLOAD];
                } else {
                  assertBindTaskInfo.value.bindStatus =
                      assertBindTaskInfo.value.bindStatusPre;
                  assertBindTaskInfo.value.bindStatusText =
                      MOULD_BIND_STATUS[assertBindTaskInfo.value.bindStatusPre];
                }
              }
            } else {
              if (showAllLabels.length > 0 &&
                  assertBindTaskInfo
                          .value.nameplatePhoto?.fullPath?.isNotEmpty ==
                      true &&
                  assertBindTaskInfo.value.address != null) {
                assertBindTaskInfo.value.bindStatus =
                    BIND_STATUS_WAITING_UPLOAD;
                assertBindTaskInfo.value.bindStatusText =
                    MOULD_BIND_STATUS[BIND_STATUS_WAITING_UPLOAD];
              } else {
                assertBindTaskInfo.value.bindStatus =
                    assertBindTaskInfo.value.bindStatusPre;
                assertBindTaskInfo.value.bindStatusText =
                    MOULD_BIND_STATUS[assertBindTaskInfo.value.bindStatusPre];
              }
            }

            var st = homeController.mouldBindList.value.data
                ?.where((element) =>
                    element.taskNo == taskNo && element.taskType == taskType)
                .first
                .mouldList
                ?.where((element) => taskType == MOULD_TASK_TYPE_PAY
                    ? element.assetBindTaskId == bindId
                    : element.labelReplaceTaskId == bindId)
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
