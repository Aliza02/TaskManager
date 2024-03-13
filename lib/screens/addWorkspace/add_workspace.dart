import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';

class AddWorkspace extends StatelessWidget {
  const AddWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return header(
      child: Column(
        children: [
          text(
              title: 'Add Workspace',
              fontSize: Get.width * 0.05,
              fontWeight: AppFonts.semiBold,
              color: AppColors.black,
              align: TextAlign.start),
        ],
      ),
    );
  }
}
