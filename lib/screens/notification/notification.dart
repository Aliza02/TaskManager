import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return header(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back(
                    canPop: true,
                  );
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              text(
                title: 'Notifications',
                fontSize: Get.width * 0.06,
                fontWeight: AppFonts.bold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: Get.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: ListTile(
                    title: text(
                        title: 'You have deadline for today',
                        fontSize: Get.width * 0.04,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.black,
                        align: TextAlign.start),
                    subtitle: text(
                        title: 'workspace name',
                        fontSize: Get.width * 0.03,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.grey,
                        align: TextAlign.start),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
