import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/useful_constants.dart' as constants;

void showErrorSnackBar({required BuildContext context,
  required String message,
  Color? color = constants.colorStatusRed,
  Color? textColor = constants.white,
  SnackBarAction? action
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
      getSnackBar(
        context: context,
        content: Text(message, style: TextStyle(color: textColor),),
        backgroundColor: color,
        action: action,
      )
  );
}

SnackBar getSnackBar({
  required BuildContext context,
  required Widget content,
  Color? backgroundColor = constants.colorStatusSand,
  Color? textColor = Colors.white,
  SnackBarAction? action
}) =>
    SnackBar(
      content: content,
      duration: const Duration(seconds: 5),
      backgroundColor: backgroundColor,
      action: action,
    );