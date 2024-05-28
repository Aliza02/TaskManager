import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Utils/utils.dart';
import 'package:taskmanager/bloc/bottomNavBarBloc/states.dart';
import 'package:taskmanager/bloc/userBloc/bloc.dart';
import 'package:taskmanager/bloc/userBloc/events.dart';
import 'package:taskmanager/bloc/userBloc/states.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/constants/icons.dart';
import 'package:taskmanager/constants/image.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/widgets/text.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.workspaceGradientColor1[1],
              AppColors.workspaceGradientColor2[1],
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.user),
            RichText(
              text: TextSpan(
                text: 'Welcome to ',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: AppFonts.normal,
                  fontSize: Get.width * 0.06,
                ),
                children: [
                  const TextSpan(
                      text: 'WorkSync',
                      style: TextStyle(
                        fontWeight: AppFonts.bold,
                      )),
                ],
              ),
            ),
            text(
              title: "your all-in-one project management solution!.",
              fontSize: Get.width * 0.05,
              fontWeight: AppFonts.normal,
              color: AppColors.white,
              align: TextAlign.center,
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            BlocConsumer<LoginSignUpBloc, UserStates>(
              listener: (context, state) {
                if (state is Userloading && state.loading == false) {
                  Get.toNamed(AppRoutes.main);
                } else if (state is Userloading && state.loading == true) {
                  Utils.showtoast('Signing in');
                }
              },
              builder: (context, state) {
                if (state is EnableGoogleSignin) {
                  return SizedBox(
                    width: Get.width * 0.8,
                    height: Get.height * 0.07,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: const BeveledRectangleBorder(),
                        textStyle: const TextStyle(
                          color: AppColors.black,
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<LoginSignUpBloc>(context)
                            .add(GoogleSigning(true));
                      },
                      icon: Image.asset(
                        AppIcons.googleLogo,
                        height: Get.height * 0.04,
                      ),
                      label: text(
                        title: 'Google',
                        fontSize: Get.width * 0.05,
                        fontWeight: AppFonts.normal,
                        color: AppColors.black,
                        align: TextAlign.center,
                      ),
                    ),
                  );
                } else if (state is Userloading && state.loading == true) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      2,
                      (index) => Container(
                        width: Get.width * 0.8,
                        height: Get.height * 0.07,
                        margin: EdgeInsets.only(
                          bottom: Get.height * 0.02,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors
                                .workspaceGradientColor1[1]
                                .withOpacity(0.7),
                            shape: const BeveledRectangleBorder(),
                          ),
                          onPressed: () {
                            BlocProvider.of<LoginSignUpBloc>(context)
                                .add(LoginSignupEvent());
                          },
                          child: text(
                              title: ["Login", "Signup"][index],
                              fontSize: Get.width * 0.04,
                              fontWeight: AppFonts.semiBold,
                              color: AppColors.white,
                              align: TextAlign.start),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
