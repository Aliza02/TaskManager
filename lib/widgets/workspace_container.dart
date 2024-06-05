import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_status/flutter_progress_status.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/widgets/members_container.dart';
import 'package:taskmanager/widgets/text.dart';

class WorkSpaceContainer extends StatelessWidget {
  final Color color1;
  final Color color2;
  final bool all;
  final String projectName;
  final int membersLength;
  final String projectId;
  final String projectCreationDate;

  const WorkSpaceContainer(
      {super.key,
      required this.color1,
      required this.color2,
      required this.all,
      required this.projectName,
      required this.membersLength,
      required this.projectId,
      required this.projectCreationDate});

  @override
  Widget build(BuildContext context) {
    var project = locator<Database>;
    return Container(
      width: Get.width * 0.5,
      margin: EdgeInsets.only(
        top: Get.height * 0.02,
        left: Get.width * 0.04,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 1,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2],
        ),
        borderRadius: BorderRadius.circular(
          Get.width * 0.04,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              // alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: Get.height * 0.02,
              ),
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Text(
                projectName,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: AppFonts.bold,
                  color: AppColors.white,
                ),
              )),
          Container(
            margin: EdgeInsets.only(
              top: Get.height * 0.01,
              left: Get.width * 0.04,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                ),
                text(
                  title: projectCreationDate,
                  fontSize: Get.width * 0.03,
                  fontWeight: AppFonts.bold,
                  color: AppColors.white,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          WorkSpaceMembers(
            membersLength: membersLength,
          ),
          all == false
              ? Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                    left: Get.width * 0.04,
                    bottom: Get.height * 0.01,
                  ),
                  margin: EdgeInsets.only(
                    top: Get.height * 0.012,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text(
                        title: "Progress",
                        fontSize: Get.width * 0.04,
                        align: TextAlign.start,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.03,
                        ),
                        child: FutureBuilder(
                          future: project().getProgress(id: projectId),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ProgressStatus(
                                backgroundColor: Colors.grey,
                                strokeWidth: 3,
                                fillValue: snapshot.data!.isNaN
                                    ? 0
                                    : snapshot.data! * 100,
                                isStrokeCapRounded: true,
                                centerTextStyle: TextStyle(
                                  color: AppColors.white,
                                  fontSize: Get.width * 0.024,
                                ),
                                fillColor: Colors.white,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          all
              ? FutureBuilder(
                  future: project().getProgress(id: projectId),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            width: Get.width * 0.3,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              left: Get.width * 0.04,
                              top: Get.height * 0.013,
                            ),
                            
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Get.width * 0.03,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: text(
                              title: snapshot.data! * 100 == 100
                                  ? "Completed"
                                  : "In Progress",
                              fontSize: Get.width * 0.04,
                              align: TextAlign.start,
                              fontWeight: AppFonts.semiBold,
                              color: AppColors.black,
                            ),
                          );
                  })
              : SizedBox(),
        ],
      ),
    );
  }
}
