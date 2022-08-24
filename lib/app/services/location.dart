import 'dart:async';
import 'dart:ffi';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:inventory_app/app/entity/LocationInfo.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/widgets/toast.dart';
import 'package:get/get.dart';

/**
 * 高德定位服务
 */
class LocationMapService extends GetxController {
  static LocationMapService get to => Get.find();

  var locationResult = LocationInfo().obs;

  StreamSubscription<Map<String, Object>>? locationListener = null;

  AMapFlutterLocation _locationPlugin = AMapFlutterLocation();

  void initMap() {
    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作
    ///
    /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    /// <b>必须保证在调用定位功能之前调用， 建议首次启动App时弹出《隐私政策》并取得用户同意</b>
    ///
    /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    ///
    /// [hasContains] 隐私声明中是否包含高德隐私政策说明
    ///
    /// [hasShow] 隐私权政策是否弹窗展示告知用户
    AMapFlutterLocation.updatePrivacyShow(true, true);

    /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作
    ///
    /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    ///
    /// <b>必须保证在调用定位功能之前调用, 建议首次启动App时弹出《隐私政策》并取得用户同意</b>
    ///
    /// [hasAgree] 隐私权政策是否已经取得用户同意
    AMapFlutterLocation.updatePrivacyAgree(true);

    /// 动态申请定位权限
    // requestPermission();

    locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      Log.d("定位信息：${result}");
      toastInfo(msg: '定位成功');
      locationResult.value.address = result['address'] as String;
      locationResult.value.lat = result['latitude'] as double;
      locationResult.value.lng = result['longitude'] as double;
    });
  }

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    // bool hasLocationPermission = await requestLocationPermission();
    bool hasLocationPermission = true;
    if (hasLocationPermission) {
      toastInfo(msg: "定位权限申请通过");
    } else {
      toastInfo(msg: "定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  // Future<bool> requestLocationPermission() async {
  //   //获取当前的权限
  //   var status = await Permission.location.status;
  //   if (status == PermissionStatus.granted) {
  //     //已经授权
  //     return true;
  //   } else {
  //     //未授权则发起一次申请
  //     status = await Permission.location.request();
  //     if (status == PermissionStatus.granted) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  // }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = new AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = true;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 5000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  ///开始定位
  void startLocation() {
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  ///停止定位
  void stopLocation() {
    _locationPlugin.stopLocation();
    locationResult.value = LocationInfo();
    _locationPlugin.destroy();
  }
}
