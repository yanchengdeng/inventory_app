import 'package:flutter/material.dart';
import 'package:inventory_app/app/values/fontsize.dart';

/// 文本样式

///列表 支付编号样式
TextStyle textBoldListTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
  );
}

///常规字体样式
TextStyle textNormalListTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
  );
}

///加粗字体样式
TextStyle textBoldNumberStyle() {
  return TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.black,
    fontSize: AppFontSize.FONT_SIZE_TITLE.toDouble(),
  );
}

///加粗字体样式
TextStyle textBoldNumberWhiteStyle() {
  return TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontSize: AppFontSize.FONT_SIZE_TITLE.toDouble(),
  );
}

///加粗字体样式
TextStyle textBoldNumberBlueStyle() {
  return TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.blue,
    fontSize: AppFontSize.FONT_SIZE_TITLE.toDouble(),
  );
}

///字体样式
TextStyle textNormalTextBlueStyle() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.blue,
    fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
  );
}

///字体样式 用作 floatButton 样式
TextStyle textFloatButtonStyle() {
  return TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontSize: AppFontSize.FONT_SIZE_FLOAT.toDouble(),
  );
}

///字体样式
TextStyle textSmallTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w200,
    color: Colors.black,
    fontSize: AppFontSize.FONT_SIZE_DESCRIBLE.toDouble(),
  );
}

///常规字体样式
TextStyle textLitleWhiteTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
  );
}

///常规字体样式
TextStyle textLitleBlackTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
  );
}

///常规字体样式
TextStyle textLitleOrangeTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.orange,
    fontSize: AppFontSize.FONT_SIZE_FLOAT.toDouble(),
  );
}

///常规字体样式
TextStyle textLitleRedTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.red,
    fontSize: AppFontSize.FONT_SIZE_FLOAT.toDouble(),
  );
}

///常规字体样式
TextStyle textLitleGreenTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Color.fromARGB(255, 34, 255, 144),
    fontSize: AppFontSize.FONT_SIZE_FLOAT.toDouble(),
  );
}

///常规字体样式
TextStyle textLitleBlueTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Color.fromARGB(255, 14, 134, 231),
    fontSize: AppFontSize.FONT_SIZE_FLOAT.toDouble(),
  );
}
