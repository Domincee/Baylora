import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AppFeedback {
  static void success(BuildContext context, String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  static void error(BuildContext context, String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  static Future<void> showLoading({String? status}) async {
    await EasyLoading.show(status: status ?? 'Loading...');
  }

  static Future<void> hideLoading() async {
    await EasyLoading.dismiss();
  }
}