import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';

class WorkSpaceMembers extends StatelessWidget {


  const WorkSpaceMembers({super.key});
  @override
  Widget build(BuildContext context) {
    var member=locator<Database>;
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
                child: 
                Icon(Icons.person),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Get.width * 0.06,
                ),
                child: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Get.width * 0.12,
                ),
                child: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Get.width * 0.18,
                ),
                child: CircleAvatar(
                  child: Text("10+"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
