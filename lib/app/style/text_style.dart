import 'package:flutter/material.dart';
import 'package:inventory_app/app/style/style.dart';
import 'package:inventory_app/app/values/fontsize.dart';

/// 文本样式

///列表 支付编号样式
TextStyle textBoldListTextStyle(){
  return   TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
  );
}

///常规字体样式
TextStyle textNormalListTextStyle(){
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
  );
}


///加粗字体样式
TextStyle textBoldNumberStyle(){
  return   TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.black,
    fontSize: AppFontSize.FONT_SIZE_TITLE.toDouble(),
  );
}


