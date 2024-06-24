import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/constants/icons.dart';
import 'package:taskmanager/constants/labels.dart';
import 'package:taskmanager/data/Authentications/google_signin.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/widgets/text.dart';

class TaskTile extends StatefulWidget {
  final String taskName;
  final String id;
  final String deadlineDate;
  final String deadlineTime;
  final String projectName;
  final Function onRemove;
  final int index;
  final Animation<double> animation;
  final bool enableProgressButton;
  final bool disableSlideButton;
  final String taskStatus;
  const TaskTile(
      {super.key,
      required this.taskName,
      required this.onRemove,
      required this.index,
      required this.animation,
      required this.deadlineDate,
      required this.deadlineTime,
      required this.projectName,
      required this.enableProgressButton,
      required this.disableSlideButton,
      required this.id,
      required this.taskStatus});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  var project = locator<Database>;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: List.generate(
            widget.disableSlideButton == true
                ? 0
                : widget.enableProgressButton == true
                    ? 2
                    : 1,
            (index) => Expanded(
              child: InkWell(
                onTap: () {
                  if (widget.enableProgressButton == true && index == 0) {
                    print('progress');
                    widget.onRemove();
                    project().updateTaskStatus(
                        taskName: widget.taskName,
                        changeStatusTo: 'inProgress');
                    setState(() {});
                  } else {
                    project().updateTaskStatus(
                        taskName: widget.taskName, changeStatusTo: 'Completed');
                    widget.onRemove();
                    print('compelterd');
                  }
                },
                child: Container(
                  width: Get.width * 0.24,
                  height: Get.height * 0.09,
                  margin: EdgeInsets.only(
                    right: Get.width * 0.02,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: [
                      Color(0xFF21B7CA),
                      AppColors.workspaceGradientColor1[1]
                    ][widget.enableProgressButton == true ? index : 1],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(
                        title: AppLabels.slidingTitleLabel[
                            widget.enableProgressButton == true ? index : 1],
                        fontSize: Get.width * 0.04,
                        fontWeight: AppFonts.bold,
                        color: AppColors.white,
                        align: TextAlign.start,
                      ),
                      Icon(
                        AppIcons.slidingTileIcon[
                            widget.enableProgressButton == true ? index : 1],
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: Get.height * 0.01,
            horizontal: Get.width * 0.05,
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: ListTile(
            title: text(
              title: widget.taskName,
              fontSize: Get.width * 0.04,
              fontWeight: AppFonts.bold,
              color: AppColors.black,
              align: TextAlign.start,
            ),
            subtitle: text(
              title:
                  "${widget.deadlineTime}.${widget.deadlineDate}. ${widget.projectName}",
              fontSize: Get.width * 0.03,
              fontWeight: AppFonts.normal,
              color: Colors.grey,
              align: TextAlign.start,
            ),
            trailing: widget.taskStatus == 'none'
                ? IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.comment, arguments: widget.id);
                    },
                    icon: Icon(Icons.mode_comment_outlined),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
