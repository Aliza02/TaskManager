import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';
import 'package:taskmanager/widgets/workspace_container.dart';

class AllWorkspace extends StatelessWidget {
  const AllWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(
        right: Get.width * 0.03,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: Get.height * 0.05,
            ),
            child: text(
              title: 'All Workspace',
              fontSize: Get.width * 0.06,
              fontWeight: AppFonts.bold,
              color: AppColors.black,
              align: TextAlign.start,
            ),
          ),
          Expanded(
            child: GridView.builder(
                itemCount: 6,
                padding: EdgeInsets.only(
                  top: Get.height * 0.01,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.9,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.workSpaceDetail);
                    },
                    child: WorkSpaceContainer(
                      all: true,
                      color1: AppColors.workspaceGradientColor1[2],
                      color2: AppColors.workspaceGradientColor2[0],
                    ),
                  );
                }),
          )
        ],
      ),
    ));
  }
}
