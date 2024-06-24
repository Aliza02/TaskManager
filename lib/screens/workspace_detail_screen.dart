import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Utils/utils.dart';
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                    width: width * 0.4,
                    decoration: BoxDecoration(
                      color:
                          AppColors.workspaceGradientColor1[0].withOpacity(0.3),
                      borderRadius: BorderRadius.circular(
                        Get.width * 0.03,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      // horizontal: Get.width * 0.05,
                      vertical: Get.height * 0.02,
                    ),
                    margin: EdgeInsets.only(
                      top: Get.height * 0.01,
                      right: Get.width * 0.03,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                : StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(projectController
                                            .projectCreatedBy.string)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.active) {
                                        DocumentSnapshot snap = snapshot.data!;
                                        return text(
                                          title: snap.exists
                                              ? snap['userName']
                                              : "User Name",
                                          fontSize: Get.width * 0.04,
                                          fontWeight: AppFonts.semiBold,
                                          color: AppColors.black,
                                          align: TextAlign.start,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    })
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
                        return snapshot.data!.docs.isNotEmpty
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
                                    child: InkWell(
                                      onTap: () {
                                        showBottomSheet(
                                          backgroundColor: AppColors.white,
                                          elevation: 0.0,
                                          enableDrag: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              width * 0.1,
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              width: width,
                                              height: height * 0.55,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.1,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      width * 0.1),
                                                  topLeft: Radius.circular(
                                                      width * 0.1),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.grey,
                                                    blurRadius: 0.3,
                                                    spreadRadius: 0.2,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width * 0.8,
                                                    height: height * 0.01,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.grey
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        width * 0.1,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: height * 0.02,
                                                    ),
                                                    child: text(
                                                      title: "Task Details",
                                                      fontSize: width * 0.06,
                                                      fontWeight: AppFonts.bold,
                                                      color: AppColors.black,
                                                      align: TextAlign.center,
                                                    ),
                                                  ),
                                                  Divider(),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  text(
                                                    title: "Task Name",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                  text(
                                                    title: snap['taskName'],
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.grey,
                                                    align: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  text(
                                                    title: "Description",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                  text(
                                                    title: snap['description'],
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.grey,
                                                    align: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  text(
                                                    title: "Assigned to:",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                  ListView.builder(
                                                    itemCount:
                                                        snap['Members'].length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return text(
                                                        title: snap['Members']
                                                                [index]
                                                            .toString(),
                                                        fontSize: width * 0.04,
                                                        fontWeight:
                                                            AppFonts.medium,
                                                        color: AppColors.grey,
                                                        align: TextAlign.start,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  text(
                                                    title: "Deadline",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                  text(
                                                    title:
                                                        "${snap['deadlineDate']} | ${snap['deadlineTime']}",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.grey,
                                                    align: TextAlign.start,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      vertical: height * 0.02,
                                                    ),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: AppColors
                                                            .workspaceGradientColor1[1],
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: text(
                                                        title: "Close",
                                                        fontSize: width * 0.04,
                                                        fontWeight:
                                                            AppFonts.bold,
                                                        color: AppColors.white,
                                                        align: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      onLongPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: AppColors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Get.width * 0.02,
                                                ),
                                              ),
                                              elevation: 0.0,
                                              title: text(
                                                title: "Delete Task",
                                                fontSize: Get.width * 0.065,
                                                fontWeight: AppFonts.bold,
                                                color: AppColors.black,
                                                align: TextAlign.center,
                                              ),
                                              actions: List.generate(
                                                2,
                                                (index) => ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0.0,
                                                    backgroundColor: AppColors
                                                        .workspaceGradientColor1[
                                                            index]
                                                        .withOpacity(0.3),
                                                  ),
                                                  onPressed: () async {
                                                    if (index == 0) {
                                                      Get.back();
                                                    } else {
                                                      Get.back();
                                                      Utils.showtoast(
                                                          "Task has been deleted");
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("Tasks")
                                                          .doc(projectController
                                                              .projectId.value
                                                              .toString())
                                                          .collection(
                                                              "projectTasks")
                                                          .doc(snap.id)
                                                          .delete();
                                                    }
                                                  },
                                                  child: text(
                                                    title: [
                                                      "Cancel",
                                                      "Delete"
                                                    ][index],
                                                    fontSize: Get.width * 0.04,
                                                    fontWeight:
                                                        AppFonts.semiBold,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              content: Container(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.white,
                                                ),
                                                child: text(
                                                  title:
                                                      "Are you sure you want to delete this Task?",
                                                  fontSize: Get.width * 0.04,
                                                  fontWeight: AppFonts.regular,
                                                  color: AppColors.grey,
                                                  align: TextAlign.start,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
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
