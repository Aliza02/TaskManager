import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Utils/utils.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_bloc.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_events.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_states.dart';
import 'package:taskmanager/bloc/bottomNavBarBloc/bloc.dart';
import 'package:taskmanager/bloc/bottomNavBarBloc/events.dart';
import 'package:taskmanager/bloc/memberBloc/member_bloc.dart';
import 'package:taskmanager/bloc/memberBloc/member_events.dart';
import 'package:taskmanager/bloc/memberBloc/member_states.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';

import 'package:taskmanager/screens/workspace/chips.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';
import 'package:taskmanager/widgets/workspace/task_field.dart';

class AddWorkspace extends StatefulWidget {
  const AddWorkspace({super.key});

  @override
  State<AddWorkspace> createState() => _AddWorkspaceState();
}

class _AddWorkspaceState extends State<AddWorkspace>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  List<String> memberEmails = [];
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController projectName = TextEditingController();
    TextEditingController projectDesc = TextEditingController();
    TextEditingController memberEmail = TextEditingController();

    return header(
      child: SingleChildScrollView(
        key: ValueKey<int>(2),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: text(
                  title: 'Add Project',
                  fontSize: Get.width * 0.06,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.black,
                  align: TextAlign.start),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              child: text(
                title: 'Project Name',
                fontSize: Get.width * 0.06,
                fontWeight: AppFonts.semiBold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            TaskField(
              onPressed: () {},
              isMember: false,
              controller: projectName,
              NoOfLine: 1,
              deadline: false,
              title: 'Mobile Design',
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              child: text(
                title: 'Project Description',
                fontSize: Get.width * 0.06,
                fontWeight: AppFonts.semiBold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            TaskField(
              onPressed: () {},
              isMember: false,
              controller: projectDesc,
              NoOfLine: 8,
              deadline: false,
              title: 'Lorem Ipsum',
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.01,
              ),
              child: text(
                title: 'Add Members',
                fontSize: Get.width * 0.06,
                fontWeight: AppFonts.semiBold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            TaskField(
              onPressed: () {
                BlocProvider.of<MemberBloc>(context)
                    .add(AddMember(memberEmail.text));
                controller.forward();
                memberEmails.add(memberEmail.text);
                memberEmail.clear();
              },
              isMember: true,
              controller: memberEmail,
              NoOfLine: 1,
              deadline: false,
              title: 'i.e: abc@gmail.com',
            ),
            BlocConsumer<MemberBloc, MembersStates>(
              listener: (context, state) {
                if (state is MemberErrorState) {
                  Utils.showSnackBar(state.message);
                }
              },
              builder: (context, state) {
                if (state is MemberAdded) {
                  print(state.members.length);
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Wrap(
                      spacing: 2,
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
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Wrap(
                      spacing: 2,
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
                } else {
                  return Container();
                }
              },
            ),
            Container(
              width: Get.width,
              height: Get.height * 0.07,
              padding: EdgeInsets.symmetric(
                  // vertical: Get.height * 0.01,
                  ),
              margin: EdgeInsets.only(
                top: Get.height * 0.02,
                bottom: Get.height * 0.02,
              ),
              child: ElevatedButton(
                onPressed: () {
                  DateTime? date = DateTime.now();
                  BlocProvider.of<ProjectBloc>(context).add(AddProject(
                      projectName.text,
                      projectDesc.text,
                      memberEmails,
                      "${date.day}/${date.month}/${date.year}"));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.workspaceGradientColor1[2],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Get.width * 0.03,
                    ),
                  ),
                ),
                child: text(
                  title: 'Add Project',
                  fontSize: Get.width * 0.05,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.white,
                  align: TextAlign.start,
                ),
              ),
            ),
            BlocListener<ProjectBloc, ProjectStates>(
              listener: (context, state) {
                if (state is ProjectAdded) {
                  Utils.showSnackBar(state.message);

                  BlocProvider.of<NavBarBloc>(context)
                      .add(currentPage(index: 2));

                  projectDesc.clear();
                  projectName.clear();
                  BlocProvider.of<MemberBloc>(context).add(AddAllMember());
                } else if (state is ErrorState) {
                  Utils.showSnackBar(state.message);
                }
              },
              child: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
