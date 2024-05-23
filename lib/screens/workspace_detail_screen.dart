import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/constants/labels.dart';
import 'package:taskmanager/controllers/project_controller.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/widgets/text.dart';

class WorkspaceDetail extends StatelessWidget {
  const WorkspaceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final projectController = Get.put(ProjectController());

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            2,
            (index) => SizedBox(
              width: Get.width * 0.4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.workspaceGradientColor1[index],
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.05,
                    vertical: Get.height * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Get.width * 0.03,
                    ),
                  ),
                ),
                onPressed: () {
                  if (index == 0) {
                    Get.toNamed(AppRoutes.addMember);
                  } else if (index == 1) {
                    Get.toNamed(AppRoutes.addTask);
                  } else {}
                },
                child: text(
                  title: AppLabels.projectDetailButtonLabel[index],
                  fontSize: Get.width * 0.04,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.white,
                  align: TextAlign.start,
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offNamed(AppRoutes.main);
          },
        ),
        title: text(
          color: AppColors.black,
          title: "Workspace Details",
          fontSize: Get.width * 0.06,
          fontWeight: AppFonts.semiBold,
          align: TextAlign.start,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06,
            vertical: Get.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                title: projectController.projectName.string,
                fontSize: Get.width * 0.06,
                fontWeight: AppFonts.bold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  2,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color:
                          AppColors.workspaceGradientColor1[0].withOpacity(0.3),
                      borderRadius: BorderRadius.circular(
                        Get.width * 0.03,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                      vertical: Get.height * 0.02,
                    ),
                    margin: EdgeInsets.only(
                      top: Get.height * 0.01,
                      right: Get.width * 0.03,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            // horizontal: Get.width * 0.03,
                            right: Get.width * 0.012,
                          ),
                          child: Icon(
                            [
                              Icons.calendar_month_outlined,
                              Icons.people
                            ][index],
                            size: Get.width * 0.08,
                            color: AppColors.workspaceGradientColor2[0],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(
                              title: AppLabels.projectDetailLabel[index],
                              fontSize: Get.width * 0.035,
                              fontWeight: AppFonts.normal,
                              color: AppColors.grey,
                              align: TextAlign.start,
                            ),
                            index == 0
                                ? text(
                                    title: projectController
                                        .projectCreationDate.value,
                                    fontSize: Get.width * 0.04,
                                    fontWeight: AppFonts.semiBold,
                                    color: AppColors.black,
                                    align: TextAlign.start,
                                  )
                                : Row(
                                    children: List.generate(
                                      3,
                                      (index) => Icon(Icons.person),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.01,
                ),
                child: text(
                  title: 'Description',
                  fontSize: Get.width * 0.05,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.black,
                  align: TextAlign.start,
                ),
              ),
              text(
                title: projectController.projectDescription.string,
                fontSize: Get.width * 0.04,
                fontWeight: AppFonts.normal,
                color: AppColors.grey,
                align: TextAlign.start,
              ),
              Padding(
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
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Tasks')
                        .doc(projectController.projectId.string)
                        .collection('projectTasks')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return snapshot.data!.docs.length != 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: Get.height * 0.01,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(
                                        10.0,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: text(
                                        title: snap['taskName'],
                                        fontSize: Get.width * 0.04,
                                        fontWeight: AppFonts.bold,
                                        color: AppColors.black,
                                        align: TextAlign.start,
                                      ),
                                      subtitle: text(
                                        title:
                                            "${snap['deadlineDate']}. ${snap['deadlineTime']}. ${projectController.projectName.value}",
                                        fontSize: Get.width * 0.03,
                                        fontWeight: AppFonts.normal,
                                        color: Colors.grey,
                                        align: TextAlign.start,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: text(
                                    title: 'No task added',
                                    fontSize: Get.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                    align: TextAlign.center),
                              );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
