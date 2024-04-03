import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';

class TaskField extends StatelessWidget {
  final String title;
  final int NoOfLine;
  final bool deadline;
  final TextEditingController controller;
  final bool isMember;
  final Function onPressed;
  const TaskField(
      {super.key,
      required this.title,
      required this.NoOfLine,
      required this.deadline,
      required this.controller,
      required this.isMember,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: NoOfLine,
      decoration: InputDecoration(
        suffixIcon: deadline == true
            ? title == 'Date'
                ? IconButton(
                    onPressed: () {
                      onPressed();
                    },
                    icon: Icon(Icons.calendar_month))
                : IconButton(
                    onPressed: () {
                      onPressed();
                    },
                    icon: Icon(Icons.timer_outlined),
                  )
            : isMember
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      onPressed();
                    },
                  )
                : const SizedBox(),
        hintText: title,
        hintStyle: TextStyle(
          color: AppColors.grey,
          fontSize: Get.width * 0.04,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Get.width * 0.03),
          borderSide: BorderSide(
            color: AppColors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Get.width * 0.03),
          borderSide: BorderSide(
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}
