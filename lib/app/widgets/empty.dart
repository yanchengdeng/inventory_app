import 'package:flutter/material.dart';
import 'package:inventory_app/app/style/text_style.dart';

Widget DefaultEmptyWidget() {
  return Container(
    height: 300,
    child: Column(
      children: [
        Spacer(),
        Text(
          '暂无数据',
          style: textBoldNumberStyle(),
        )
      ],
    ),
  );
}
