
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_app/core/app_constant.dart';

class AppUtil {
  static void showToast(String msg) {
    try {
      Fluttertoast.showToast(
          msg: msg,
          backgroundColor: AppConstant.customBlack,
          textColor: AppConstant.customWhite);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: AppConstant.customWhite);
    }
  }
}
