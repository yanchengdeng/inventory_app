import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/app/style/text_style.dart';

/***
 * 暂无数据
 */

Widget DefaultEmptyWidget() {
  return Container(
    height: 300,
    child: Center(
      child: Column(
        children: [
          Spacer(),
          Image(
            image: AssetImage('images/no_data.png'),
            width: 100,
            height: 100,
          ),
          Container(
              margin: EdgeInsetsDirectional.only(top: 10),
              child: Text(
                '暂无数据',
                style: textBoldNumberStyle(),
              ))
        ],
      ),
    ),
  );
}
