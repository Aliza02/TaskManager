import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/controllers/project_controller.dart';
import 'package:taskmanager/data/Authentications/google_signin.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';

class WorkSpaceMembers extends StatelessWidget {
  final int membersLength;
  const WorkSpaceMembers({super.key, required this.membersLength});
  @override
  Widget build(BuildContext context) {
    final projectController = Get.put(ProjectController());
    var project = locator<Database>;
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: Get.width * 0.04,
            top: Get.height * 0.01,
          ),
          child: Stack(
            children: [
              StreamBuilder(
                  stream: project().getUserDetail(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // DocumentSnapshot user = snapshot.data!.docs[0];
                      return CircleAvatar(
                        child: ClipOval(
                          child: snapshot.data!.docs.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: snapshot.data!.docs[0]['photoUrl']
                                      .toString())
                              : Icon(Icons.person),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              membersLength != 0 && membersLength == 2
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .where('email',
                              isEqualTo: projectController.members[1])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data!.docs[0]);
                          return Container(
                          margin: EdgeInsets.only(
                            left: Get.width * 0.06,
                          ),
                          child: CircleAvatar(
                            child: ClipOval(
                                child: snapshot.data!.docs.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.docs[0]['photoUrl']
                                            .toString(),
                                      )
                                    : Icon(Icons.person)),
                          ),
                        );
                        }else{
                          return Container();
                        }
                        
                      })
                  : SizedBox(),
              membersLength >= 3
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
