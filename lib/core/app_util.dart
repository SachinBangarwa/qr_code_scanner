import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtil {
  static void showToast(String msg) {
    try {
      Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.green,
          textColor: Colors.white);
    }
  }
}
