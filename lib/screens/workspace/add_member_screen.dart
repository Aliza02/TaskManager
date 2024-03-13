import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: Get.height * 0.02,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: text(
                      title: 'Member Name',
                      fontSize: Get.width * 0.04,
                      fontWeight: AppFonts.regular,
                      color: AppColors.black,
                      align: TextAlign.start),
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: AppColors.workspaceGradientColor1[1],
                      )),
                );
              },
            ),
          ),
          Container(
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
              onPressed: () {},
              child: text(
                  title: 'Add',
                  fontSize: Get.width * 0.04,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.black,
                  align: TextAlign.start),
            ),
          ),
        ],
      ),
    );
  }
}
