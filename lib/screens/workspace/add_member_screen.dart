import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Utils/utils.dart';
import 'package:taskmanager/bloc/addMemberToProject/addMemberBloc.dart';
import 'package:taskmanager/bloc/addMemberToProject/addMemberstates.dart';
import 'package:taskmanager/bloc/addMemberToProject/addmemberevents.dart';
import 'package:taskmanager/bloc/removeMemberFromProjectBloc/removeMember_bloc.dart';
import 'package:taskmanager/bloc/removeMemberFromProjectBloc/removeMember_events.dart';
import 'package:taskmanager/bloc/removeMemberFromProjectBloc/removeMember_states.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/controllers/project_controller.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final projectController = Get.put(ProjectController());
    final TextEditingController emailController = TextEditingController();
    var project = locator<Database>;
    return header(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                    vertical: Get.height * 0.02,
                  ),
                  child: text(
                      title: 'Add Members',
                      fontSize: Get.width * 0.05,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.black,
                      align: TextAlign.start),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofillHints: [AutofillHints.email],
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_add_alt_1_outlined),
              ),
              hintText: "i.e: abc@gmail.com",
              hintStyle: TextStyle(
                color: AppColors.grey,
                fontSize: Get.width * 0.04,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Get.width * 0.03),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Get.width * 0.03),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: Get.height * 0.02),
            child: text(
                title: 'Added Members',
                fontSize: Get.width * 0.03,
                fontWeight: AppFonts.semiBold,
                color: AppColors.grey,
                align: TextAlign.start),
          ),
          Expanded(
            child: StreamBuilder<Object>(
                stream: project().getMembersOfProject(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                          ConnectionState.active &&
                      snapshot.hasData) {
                    DocumentSnapshot snap = snapshot.data as DocumentSnapshot;

                    return snap['email'].length != 0
                        ? ListView.builder(
                            padding: EdgeInsets.only(
                              top: Get.height * 0.02,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: snap['email'].length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: text(
                                    title: snap['email'][index],
                                    fontSize: Get.width * 0.04,
                                    fontWeight: AppFonts.regular,
                                    color: AppColors.black,
                                    align: TextAlign.start),
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                trailing: BlocListener<
                                    RemoveMemberFromProjectBloc,
                                    RemoveMemberFromProjectStates>(
                                  listener: (context, state) {
                                    print(state);
                                    if (state
                                        is MemberRemovedFromProjectState) {
                                      Utils.showSnackBar(state.message);
                                    } else if (state is ErrorState) {
                                      Utils.showSnackBar(state.message);
                                    }
                                  },
                                  child: IconButton(
                                      onPressed: () {
                                        // print(snap['email'][index]);
                                        BlocProvider.of<
                                                    RemoveMemberFromProjectBloc>(
                                                context)
                                            .add(RemoveMemberFromProject(
                                                memberEmail: snap['email']
                                                    [index]));
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: AppColors
                                            .workspaceGradientColor1[1],
                                      )),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: text(
                              title: "No Member Added to Display",
                              fontSize: Get.width * 0.04,
                              fontWeight: AppFonts.semiBold,
                              color: AppColors.black,
                              align: TextAlign.center,
                            ),
                          );
                  } else {
                    return Container();
                  }
                }),
          ),
          BlocListener<AddMemberToProjectBloc, AddMemberToProjectStates>(
            listener: (context, state) {
              if (state is MemberAddedToProjectState) {
                Utils.showSnackBar(state.message);
              } else if (state is AddErrorState) {
                Utils.showSnackBar(state.message);
              }
            },
            child: Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.01,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.workspaceGradientColor1[2],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Get.width * 0.03),
                  ),
                ),
                onPressed: () {
                  BlocProvider.of<AddMemberToProjectBloc>(context).add(
                      AddMemberToProject(memberEmail: emailController.text));
                  emailController.clear();
                },
                child: text(
                    title: 'Add',
                    fontSize: Get.width * 0.04,
                    fontWeight: AppFonts.semiBold,
                    color: AppColors.black,
                    align: TextAlign.start),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
