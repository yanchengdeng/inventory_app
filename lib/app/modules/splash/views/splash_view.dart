import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_app/app/utils/http.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:logger/logger.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('授权登录'),
        centerTitle: true,
      ),
      body: WebView(
        //初始化的页面
        initialUrl: 'https://flutter.cn',
        //允许js 执行
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
          Log.d('onWebViewCreated==$controller');
          Log.d('onWebViewCreated==$_controller');
        },
        //js 交互通道
        javascriptChannels: <JavascriptChannel>{
          _showJavascriptChannel(context)
        },
        navigationDelegate: (NavigationRequest request) {
          ///拦截操作
          // return NavigationDecision.prevent;
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          Log.d('onPageStarted=$url');
        },
        onPageFinished: (String url) {
          Log.d('onPageFinished=$url');
        },
        onProgress: (int progress) {
          Log.d('onProgress=$progress');
        },
        // gestureNavigationEnabled: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  JavascriptChannel _showJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'ShowChannel',
        onMessageReceived: (JavascriptMessage message) {
          Get.snackbar('弹出JavascriptChannel信息', message.message);
        });
  }
}
