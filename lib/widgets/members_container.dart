import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';

class WorkSpaceMembers extends StatelessWidget {
  final int membersLength;
  const WorkSpaceMembers({super.key, required this.membersLength});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: Get.width * 0.04,
            top: Get.height * 0.01,
          ),
          child: Stack(
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Get.width * 0.06,
                ),
                child: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
              // membersLength == 3
              //     ? Container(
              //         margin: EdgeInsets.only(
              //           left: Get.width * 0.12,
              //         ),
              //         child: const CircleAvatar(
              //           child: Icon(Icons.person),
              //         ),
              //       )
              //     : SizedBox(),
              membersLength == 3
                  ? SizedBox()
                  : membersLength > 3
                      ? Container(
                          margin: EdgeInsets.only(
                            left: Get.width * 0.12,
                          ),
                          child: CircleAvatar(
                            child: Text("${membersLength - 3}+"),
                          ),
                        )
                      : SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}
