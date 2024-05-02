import 'package:flutter/material.dart';
import 'package:flutter_progress_status/flutter_progress_status.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/widgets/members_container.dart';
import 'package:taskmanager/widgets/text.dart';

class WorkSpaceContainer extends StatelessWidget {
  final Color color1;
  final Color color2;
  final bool all;
  final String projectName;

  const WorkSpaceContainer(
      {super.key,
      required this.color1,
      required this.color2,
      required this.all,
      required this.projectName});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Get.height * 0.25,
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
                  title: '12/12/2021',
                  fontSize: Get.width * 0.03,
                  fontWeight: AppFonts.bold,
                  color: AppColors.white,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          WorkSpaceMembers(),
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
                        child: ProgressStatus(
                          backgroundColor: Colors.grey,
                          strokeWidth: 3,
                          fillValue: 55,
                          isStrokeCapRounded: true,
                          centerTextStyle: TextStyle(
                            color: AppColors.white,
                            fontSize: Get.width * 0.024,
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          all
              ? Container(
                  width: Get.width * 0.3,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: Get.width * 0.04,
                    top: Get.height * 0.013,
                  ),
                  // padding: EdgeInsets.only(
                  //   left: Get.width * 0.04,
                  //   // bottom: Get.height * 0.01,
                  // ),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Get.width * 0.03,
                      ),
                    ),
                    color: Colors.white,
                  ),
                  child: text(
                    title: "Completed",
                    fontSize: Get.width * 0.04,
                    align: TextAlign.start,
                    fontWeight: AppFonts.semiBold,
                    color: AppColors.black,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
