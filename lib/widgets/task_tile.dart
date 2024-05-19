import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/constants/icons.dart';
import 'package:taskmanager/constants/labels.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/widgets/text.dart';

class TaskTile extends StatefulWidget {
  final String taskName;
  final String deadlineDate;
  final String deadlineTime;
  final String projectName;
  final Function onRemove;
  final int index;
  final Animation<double> animation;
  const TaskTile(
      {super.key,
      required this.taskName,
      required this.onRemove,
      required this.index,
      required this.animation,
      required this.deadlineDate,
      required this.deadlineTime,
      required this.projectName});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  var project = locator<Database>;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: List.generate(
            2,
            (index) => Expanded(
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    print('progress');
                    widget.onRemove();
                    project().updateTaskStatusToInProgress(widget.taskName);
                    setState(() {});
                  } else {
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
                    ][index],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(
                        title: AppLabels.slidingTitleLabel[index],
                        fontSize: Get.width * 0.04,
                        fontWeight: AppFonts.bold,
                        color: AppColors.white,
                        align: TextAlign.start,
                      ),
                      Icon(
                        AppIcons.slidingTileIcon[index],
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
          ),
        ),
      ),
    );
  }
}
