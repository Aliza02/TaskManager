import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';
import 'package:taskmanager/widgets/workspace/task_field.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return header(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                Container(
                  alignment: Alignment.topLeft,
                  child: text(
                    title: 'Add Tasks',
                    align: TextAlign.start,
                    color: AppColors.black,
                    fontSize: Get.width * 0.06,
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.01,
              ),
              child: text(
                title: 'Tasks',
                fontSize: Get.width * 0.05,
                fontWeight: AppFonts.semiBold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            // TaskField(
            //     deadline: false,
            //     title: 'i.e: Designing, Development, Testing, etc.',
            //     NoOfLine: 1),
            Container(
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              alignment: Alignment.topLeft,
              child: text(
                title: 'Description',
                fontSize: Get.width * 0.05,
                fontWeight: AppFonts.semiBold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            // const TaskField(
            //     deadline: false,
            //     title: 'i.e: Designing, Development, Testing, etc.',
            //     NoOfLine: 8),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              child: text(
                title: 'Deadline',
                fontSize: Get.width * 0.05,
                fontWeight: AppFonts.semiBold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
            //     Expanded(
            //       child: Container(
            //         margin: EdgeInsets.only(
            //           right: Get.width * 0.01,
            //         ),
            //         child: const TaskField(
            //           deadline: true,
            //           title: 'Date',
            //           NoOfLine: 1,
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: Container(
            //         margin: EdgeInsets.only(
            //           left: Get.width * 0.01,
            //         ),
            //         child: const TaskField(
            //           deadline: true,
            //           title: 'Time',
            //           NoOfLine: 1,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              child: text(
                title: 'Assign to',
                align: TextAlign.start,
                color: AppColors.black,
                fontSize: Get.width * 0.05,
                fontWeight: AppFonts.semiBold,
              ),
            ),
            // const TaskField(
            //   deadline: false,
            //   title: 'Assign Members',
            //   NoOfLine: 1,
            // ),
            Container(
              margin: EdgeInsets.only(
                top: Get.height * 0.01,
              ),
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.workspaceGradientColor1[1],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: text(
                  title: 'Save',
                  fontSize: Get.width * 0.04,
                  fontWeight: AppFonts.bold,
                  color: AppColors.black,
                  align: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
