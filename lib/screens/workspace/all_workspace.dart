import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/controllers/project_controller.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';
import 'package:taskmanager/widgets/workspace_container.dart';

class AllWorkspace extends StatelessWidget {
  const AllWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    var project = locator<Database>;
    int colorIndex1 = 0;
    int colorIndex2 = 0;
    final projectController = Get.put(ProjectController());
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
              child: StreamBuilder(
                stream: project().getAllProjects(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return snapshot.data!.docs.isNotEmpty &&
                            snapshot.connectionState == ConnectionState.active
                        ? GridView.builder(
                            itemCount: snapshot.data!.docs.length,
                            padding: EdgeInsets.only(
                              top: Get.height * 0.01,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  snapshot.data!.docs[index];
                              if (colorIndex1 == 3 || colorIndex2 == 3) {
                                colorIndex1 = 0;
                                colorIndex2 = 0;
                              }

                              return InkWell(
                                onTap: () {
                                  projectController.members.clear();
                                  Get.toNamed(AppRoutes.workSpaceDetail);
                                  projectController.projectId.value =
                                      snap['projectId'];
                                  projectController.projectCreationDate.value =
                                      snap['createdOn'];
                                  projectController.projectCreatedBy.value =
                                      snap['projectCreatedBy'];
                                  projectController.projectName.value =
                                      snap['projectName'];
                                  projectController.projectDescription.value =
                                      snap['projectDescription'];
                                  projectController.members
                                      .addAll(snap['email']);
                                },
                                child: WorkSpaceContainer(
                                  projectId: snap['projectId'].toString(),
                                  projectCreationDate: snap['createdOn'],
                                  membersLength: snap['email'].length,
                                  projectName: snap['projectName'],
                                  all: true,
                                  color1: AppColors
                                      .workspaceGradientColor1[colorIndex1++],
                                  color2: AppColors
                                      .workspaceGradientColor2[colorIndex2++],
                                ),
                              );
                            },
                          )
                        : Center(
                            child: text(
                              title: 'No Workspace to display',
                              align: TextAlign.center,
                              color: AppColors.grey,
                              fontSize: Get.width * 0.045,
                              fontWeight: AppFonts.semiBold,
                            ),
                          );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
