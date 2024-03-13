import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/widgets/text.dart';

class Utils {
  static AlertDialog addMember(
      {required String title, required String content}) {
    return AlertDialog(
      title: text(
        title: 'Members',
        fontSize: Get.width * 0.05,
        fontWeight: AppFonts.semiBold,
        color: AppColors.black,
        align: TextAlign.start,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.black,
                  ),
                ),
                label: text(
                    title: 'Add Member',
                    fontSize: Get.width * 0.04,
                    fontWeight: AppFonts.normal,
                    color: AppColors.black,
                    align: TextAlign.start),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
