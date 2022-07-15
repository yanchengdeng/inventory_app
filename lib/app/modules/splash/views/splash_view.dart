import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../values/constants.dart';
import '../controllers/splash_controller.dart';

/**
 * app 启动页
 */
class SplashView extends GetView<SplashController> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('授权登录'),
        centerTitle: true,
      ),
      body: WebView(
        //初始化的页面
        initialUrl: WEB_LOGIN_URL,
        //允许js 执行
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
          Log.d('onWebViewCreated==$controller');
          Log.d('onWebViewCreated==$_controller');
        },

        //js 交互通道
        javascriptChannels: <JavascriptChannel>{
          _showJavascriptChannel(context)
        },
        navigationDelegate: (NavigationRequest request) {
          ///拦截操作
          Log.d("网页地址：${request.url}");
          if (request.url.contains('x-mid-token=')) {
            ///做拦截处理
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onWebResourceError: (WebResourceError error) {
          Log.d('onWebResourceError=$error');
        },
        onPageStarted: (String url) {
          Log.d('onPageStarted=$url');
          // EasyLoading.show(status: "加载中...");
        },
        onPageFinished: (String url) {
          Log.d('onPageFinished=$url');
          // Future.delayed(const Duration(seconds: 2),
          //     () => {EasyLoading.showSuccess("加载成功")});
        },
        onProgress: (int progress) {
          Log.d('onProgress=$progress');
        },
        // gestureNavigationEnabled: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  Future<void> _onClearCache(WebViewController controller) async {
    await controller.clearCache();
  }

  JavascriptChannel _showJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'ShowChannel',
        onMessageReceived: (JavascriptMessage message) {
          Get.snackbar('弹出JavascriptChannel信息', message.message);
        });
  }
}
