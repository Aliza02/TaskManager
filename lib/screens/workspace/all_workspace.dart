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
            child: FutureBuilder(
              future: project().getAllProjects(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    padding: EdgeInsets.only(
                      top: Get.height * 0.01,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.9,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap = snapshot.data!.docs[index];
                      print(snap.data());
                      return InkWell(
                        onTap: () {
                          projectController.members.clear();
                          Get.toNamed(AppRoutes.workSpaceDetail);
                          projectController.projectId.value = snap['projectId'];
                          projectController.projectName.value =
                              snap['projectName'];
                          projectController.projectDescription.value =
                              snap['projectDescription'];
                          projectController.members.addAll(snap['email']);
                        },
                        child: WorkSpaceContainer(
                          projectId: 'sd',
                          projectCreationDate: snap['createdOn'],
                          membersLength: 3,
                          projectName: snap['projectName'],
                          all: true,
                          color1: AppColors.workspaceGradientColor1[2],
                          color2: AppColors.workspaceGradientColor2[0],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    ));
  }
}
