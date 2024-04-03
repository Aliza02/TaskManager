import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Utils/utils.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_bloc.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_events.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_states.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';
import 'package:taskmanager/widgets/workspace/task_field.dart';

class AddWorkspace extends StatelessWidget {
  const AddWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController projectName = TextEditingController();
    TextEditingController projectDesc = TextEditingController();
    TextEditingController memberEmail = TextEditingController();

    return header(
      child: SingleChildScrollView(
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
              onPressed: () {},
              isMember: true,
              controller: memberEmail,
              NoOfLine: 1,
              deadline: false,
              title: 'i.e: Aliza',
            ),
            // Wrap(
            //   spacing: 2,
            //   children: List.generate(
            //     4,
            //     (index) => InputChip(
            //       label: Text("abc@gmail.com"),
            //       labelStyle: TextStyle(
            //           fontWeight: FontWeight.bold, color: Colors.white),
            //       backgroundColor: AppColors.workspaceGradientColor1[1],
            //       side: BorderSide(color: AppColors.white),
            //       // onPressed: () => print("input chip pressed"),
            //       deleteIconColor: Colors.white,

            //       onDeleted: () => print("input chip deleted"),
            //     ),
            //   ),
            // ),
            Container(
              width: Get.width,
              height: Get.height * 0.07,
              margin: EdgeInsets.only(
                top: Get.height * 0.02,
              ),
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ProjectBloc>(context).add(AddProject(
                    projectName.text,
                    projectDesc.text,
                    memberEmail.text,
                  ));
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
                  Get.toNamed(AppRoutes.allWorkspace);
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
