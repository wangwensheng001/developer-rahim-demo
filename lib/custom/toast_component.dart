import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
class ToastComponent {
  static showDialog(String msg, context, {duration = 0, gravity = 0}) {
    Toast.show(
      msg,
      context,
      duration: duration != 0 ? duration : Toast.LENGTH_SHORT,
      gravity: gravity != 0 ? gravity : Toast.BOTTOM,
        backgroundColor:
        Color.fromRGBO(239, 239, 239, .9),
        textColor: MyTheme.font_grey,
        border: Border(
            top: BorderSide(
              color: Color.fromRGBO(203, 209, 209, 1),
            ),bottom:BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),right: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        ),left: BorderSide(
          color: Color.fromRGBO(203, 209, 209, 1),
        )),
        backgroundRadius: 6
    );
  }
}
