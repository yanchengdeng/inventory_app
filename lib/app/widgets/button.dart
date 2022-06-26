import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_app/app/values/fontsize.dart';

import '../style/color.dart';
import '../style/text_style.dart';
import '../values/values.dart';

/// 扁平圆角按钮
Widget btnFlatButtonWidget({
  required VoidCallback onPressed,
  double width = 140,
  double height = 44,
  Color gbColor = AppColors.primaryElement,
  String title = "button",
  Color fontColor = AppColors.primaryElementText,
  double fontSize = 18,
  String fontName = "Montserrat",
  FontWeight fontWeight = FontWeight.w400,
}) {
  return Container(
    width: width.w,
    height: height.h,
    child: TextButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16.sp,
        )),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused) &&
                !states.contains(MaterialState.pressed)) {
              return Colors.blue;
            } else if (states.contains(MaterialState.pressed)) {
              return Colors.deepPurple;
            }
            return fontColor;
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue[200];
          }
          return gbColor;
        }),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: Radii.k6pxRadius,
        )),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: fontColor,
          fontFamily: fontName,
          fontWeight: fontWeight,
          fontSize: fontSize.sp,
          height: 1,
        ),
      ),
      onPressed: onPressed,
    ),
  );
}

/// 第三方按钮
Widget btnFlatButtonBorderOnlyWidget({
  required VoidCallback onPressed,
  double width = 88,
  double height = 44,
  required String iconFileName,
}) {
  return Container(
    width: width.w,
    height: height.h,
    child: TextButton(
      style: ButtonStyle(
        // textStyle: MaterialStateProperty.all(TextStyle(
        //   fontSize: 16.sp,
        // )),
        // foregroundColor: MaterialStateProperty.resolveWith(
        //   (states) {
        //     if (states.contains(MaterialState.focused) &&
        //         !states.contains(MaterialState.pressed)) {
        //       return Colors.blue;
        //     } else if (states.contains(MaterialState.pressed)) {
        //       return Colors.deepPurple;
        //     }
        //     return AppColors.primaryElementText;
        //   },
        // ),
        // backgroundColor: MaterialStateProperty.resolveWith((states) {
        //   if (states.contains(MaterialState.pressed)) {
        //     return Colors.blue[200];
        //   }
        //   return AppColors.primaryElement;
        // }),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: Radii.k6pxRadius,
        )),
      ),
      child: Image(
        image: AssetImage('$iconFileName'),
        width: 120,
        height: 120,
      ),
      onPressed: onPressed,
    ),
  );
}

//首页 选项
Widget homeItem(
    {required String title,
    required String iconFileName,
    required int unFinished}) {
  return Container(
    child: Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Image(
              image: AssetImage('$iconFileName'),
              width: 80,
              height: 80,
            ),
            unFinished > 0
                ? unReadMsgBg(color: Colors.red, count: unFinished)
                : Text('')
          ],
        ),
        Text(
          "$title",
          style: TextStyle(
              fontSize: AppFontSize.FONT_SIZE_TITLE.toDouble(),
              fontWeight: FontWeight.w400),
        )
      ],
    ),
  );
}

//红色圆形背景   适用于未读消息
Widget unReadMsgBg({required Color color, required int count}) {
  return Container(
    width: 18.0,
    height: 18.0,
    alignment: AlignmentDirectional.center,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    child: Text(
      "${count}",
      style: TextStyle(
        color: Colors.white,
        fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
      ),
    ),
  );
}

/// 两个tab 选中按钮
Widget selectTabView(
    {required String text,
    required bool selected,
    required bool isLeft,
    required VoidCallback callback}) {
  return selected
      ? InkWell(
          child: Container(
            width: 100,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                  color: AppColor.accentColor,
                  fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
                  fontWeight: FontWeight.bold),
            ),
            decoration: isLeft
                ? BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    color: Colors.white,
                    border: Border.all(color: AppColor.accentColor, width: 1))
                : BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Colors.white,
                    border: Border.all(color: AppColor.accentColor, width: 1)),
          ),
          onTap: callback,
        )
      : InkWell(
          child: Container(
            width: 100,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                  color: AppColor.secondaryText,
                  fontSize: AppFontSize.FONT_SIZE_SUB_TITLE.toDouble(),
                  fontWeight: FontWeight.bold),
            ),
            decoration: isLeft
                ? BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    color: Colors.white,
                    border: Border.all(color: AppColor.secondaryText, width: 1))
                : BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Colors.white,
                    border:
                        Border.all(color: AppColor.secondaryText, width: 1)),
          ),
          onTap: callback,
        );
}




///模具显示状态
Widget buildMouldStatusItem(
    {required String status,
    required int count,
    required VoidCallback callback}) {
  return Center(
    child: InkWell(
      onTap: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(status, style: textNormalListTextStyle()),
              Text(count.toString(), style: textBoldNumberStyle())
            ],
          )
        ],
      ),
    ),
  );
}


