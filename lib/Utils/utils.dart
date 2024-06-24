import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';

class Utils {
  static void showtoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
    );
  }

  static Future<DateTime?> showDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030));

    return picked;
  }

  static void showSnackBar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        backgroundColor: AppColors.workspaceGradientColor1[2],
        animationDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  
}
