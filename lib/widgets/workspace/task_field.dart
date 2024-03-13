import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';

class TaskField extends StatelessWidget {
  final String title;
  final int NoOfLine;
  final bool deadline;
  const TaskField(
      {super.key,
      required this.title,
      required this.NoOfLine,
      required this.deadline});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: NoOfLine,
      decoration: InputDecoration(
        suffixIcon: deadline == true
            ? title == 'Date'
                ? IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month))
                : IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.timer_outlined),
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
