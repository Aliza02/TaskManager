import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Utils/utils.dart';
import 'package:taskmanager/bloc/TaskBloc/task_bloc.dart';
import 'package:taskmanager/bloc/TaskBloc/task_states.dart';
import 'package:taskmanager/bloc/TaskBloc/task_events.dart';
import 'package:taskmanager/bloc/memberBloc/member_bloc.dart';
import 'package:taskmanager/bloc/memberBloc/member_events.dart';
import 'package:taskmanager/bloc/memberBloc/member_states.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/controllers/project_controller.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/screens/workspace/chips.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';
import 'package:taskmanager/widgets/workspace/task_field.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with SingleTickerProviderStateMixin {
// void getMembers

  var project = locator<Database>;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController task = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController date = TextEditingController();
    TextEditingController time = TextEditingController();
    TextEditingController AssignedTo = TextEditingController();
    List<String> membersTaskAssignTo = [];
    final projectController = Get.put(ProjectController());

    return header(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                Container(
                  alignment: Alignment.topLeft,
                  child: text(
                    title: 'Add Tasks',
                    align: TextAlign.start,
                    color: AppColors.black,
                    fontSize: Get.width * 0.06,
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
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
            TaskField(
                controller: task,
                isMember: false,
                onPressed: () {},
                deadline: false,
                title: 'i.e: Designing, Development, Testing, etc.',
                NoOfLine: 1),
            Container(
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              alignment: Alignment.topLeft,
              child: text(
                title: 'Description',
                fontSize: Get.width * 0.05,
                fontWeight: AppFonts.semiBold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            TaskField(
                controller: description,
                isMember: false,
                onPressed: () {},
                deadline: false,
                title: 'i.e: Designing, Development, Testing, etc.',
                NoOfLine: 8),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              child: text(
                title: 'Deadline',
                fontSize: Get.width * 0.05,
                fontWeight: AppFonts.semiBold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: Get.width * 0.01,
                    ),
                    child: TaskField(
                      controller: date,
                      isMember: false,
                      onPressed: () async {
                        DateTime? picked = await Utils.showDate(context);
                        if (picked != null) {
                          date.text =
                              "${picked.day}/${picked.month}/${picked.year}";
                        }
                      },
                      deadline: true,
                      title: 'Date',
                      NoOfLine: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: Get.width * 0.01,
                    ),
                    child: TaskField(
                      controller: time,
                      isMember: false,
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (selectedTime != null) {
                          time.text =
                              "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name}";
                        }
                      },
                      deadline: true,
                      title: 'Time',
                      NoOfLine: 1,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              child: text(
                title: 'Assign to',
                align: TextAlign.start,
                color: AppColors.black,
                fontSize: Get.width * 0.05,
                fontWeight: AppFonts.semiBold,
              ),
            ),
            TypeAheadField(
              builder: (context, AssignedTo, focusNode) {
                return TextField(
                  controller: AssignedTo,
                  focusNode: focusNode,
                  // autofocus: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Get.width * 0.03),
                      borderSide: BorderSide(
                        color: AppColors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Get.width * 0.03),
                      borderSide: const BorderSide(
                        color: AppColors.grey,
                      ),
                    ),
                    hintText: 'Members',
                  ),
                );
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  tileColor: AppColors.white,
                  title: Text(suggestion),
                );
              },
              onSelected: (value) {
                print(value);
                BlocProvider.of<MemberBloc>(context).add(AddMember(value));
                membersTaskAssignTo.add(value);
                AssignedTo.clear();
                print(membersTaskAssignTo.length);
                print(membersTaskAssignTo[0]);
              },
              suggestionsCallback: (pattern) {
                return projectController.members
                    .where((member) =>
                        member.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
            ),
            BlocBuilder<MemberBloc, MembersStates>(builder: (context, state) {
              if (state is MemberAdded) {
                print(state.members.length);
                return SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        state.members.length,
                        (index) => MemberChips(
                            memberEmail: state.members[index],
                            onDelete: () {
                              BlocProvider.of<MemberBloc>(context)
                                  .add(RemoveMember(index));
                            })),
                  ),
                );
              } else if (state is MemberRemoved) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                      state.members.length,
                      (index) => MemberChips(
                          memberEmail: state.members[index],
                          onDelete: () {
                            BlocProvider.of<MemberBloc>(context)
                                .add(RemoveMember(index));
                          })),
                );
              } else {
                return Container();
              }
            }),
            Container(
              margin: EdgeInsets.only(
                top: Get.height * 0.01,
              ),
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.workspaceGradientColor1[1],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // print(membersTaskAssignTo[0]);

                  BlocProvider.of<TaskBloc>(context).add(AddTasks(
                      taskName: task.text,
                      taskDescription: description.text,
                      deadlineDate: date.text,
                      deadlineTime: time.text,
                      member: membersTaskAssignTo));
                },
                child: text(
                  title: 'Save',
                  fontSize: Get.width * 0.04,
                  fontWeight: AppFonts.bold,
                  color: AppColors.black,
                  align: TextAlign.start,
                ),
              ),
            ),
            BlocListener<TaskBloc, TaskStates>(
              listener: (context, state) {
                if (state is TaskAdded) {
                  BlocProvider.of<MemberBloc>(context).add(AddAllMember());
                  task.clear();
                  description.clear();
                  date.clear();
                  time.clear();
                  membersTaskAssignTo.clear();
                  Get.back();
                  Utils.showSnackBar(state.message);
                } else if (state is ErrorState) {
                  Utils.showSnackBar(state.message);
                }
              },
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
