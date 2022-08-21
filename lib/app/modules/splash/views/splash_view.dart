import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/store/user.dart';
import 'package:inventory_app/app/utils/loading.dart';
import '../../../routes/app_pages.dart';
import '../../../values/constants.dart';
import '../../../widgets/toast.dart';
import '../controllers/splash_controller.dart';

/**
 * app 启动页
 */
class SplashView extends GetView<SplashController> {
  final Completer controllerCompleter = Completer<InAppWebViewController>();
  final Completer<void> pageLoaded = Completer<void>();

  @override
  Widget build(BuildContext context) {
    var isExit = false;
    return WillPopScope(
      onWillPop: () async {
        if (!isExit) {
          isExit = true;
          toastInfo(msg: '再次点击退出应用程序');
          //2秒内没有点击 isExit 从新置为false
          Future.delayed(const Duration(milliseconds: 2000), () {
            isExit = false;
          });
          return false;
        } else {
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          Get.offNamed(Routes.SPLASH);
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('授权登录'),
          centerTitle: true,
        ),
        body: InAppWebView(
          key: GlobalKey(),
          initialUrlRequest: URLRequest(url: Uri.parse(WEB_LOGIN_URL)),
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          )),
          onWebViewCreated: (controller) {
            controllerCompleter.complete(controller);
          },
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
          onLoadStart: (_controller, url) {
            print("地址onLoadStart：${url.toString()}");
            // if(url.toString() == WEB_LOGIN_URL){
            //   Loading.show('加载中...');
            // }else{
            Loading.show('登陆中...');
            // }
          },
          onLoadStop: (_controller, url) async {
            print("地址onLoadStop：$url");
            Loading.dismiss();
            String loadUrl = "${url?.toString()}";
            if (loadUrl.contains('x-mid-token=')) {
              var listSplits = loadUrl.split(SPLIT_URL);
              if (listSplits.length == 2) {
                ///保存token
                await UserStore.to.setToken(listSplits[1]);
                toastInfo(msg: '登陆成功');
                _controller.clearCache();
                pageLoaded.complete();
                Get.offAndToNamed(Routes.MAIN);
              } else {
                _controller.clearCache();
                pageLoaded.complete();
                toastInfo(msg: "页面异常");
                _controller.reload();
                _controller.loadUrl(
                    urlRequest: URLRequest(url: Uri.parse(WEB_LOGIN_URL)));
              }
            }
          },
        ),
      ),
    );
  }
}
