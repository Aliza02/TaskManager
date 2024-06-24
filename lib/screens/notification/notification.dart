import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/data/Authentications/google_signin.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    var project = locator<Database>;
    return header(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back(
                    canPop: true,
                  );
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              text(
                title: 'Notifications',
                fontSize: Get.width * 0.06,
                fontWeight: AppFonts.bold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Notifications')
                    .where('receiveTo', isEqualTo: Auth.auth.currentUser!.uid)
                    .orderBy('receiveDate', descending: true)
                    .limit(5)
                    .snapshots(),

                // project().getNotificationList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return snapshot.data!.docs.isNotEmpty &&
                            snapshot.connectionState == ConnectionState.active
                        ? ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(
                                      title: doc['receiveDate'],
                                      fontSize: Get.width * 0.04,
                                      fontWeight: AppFonts.semiBold,
                                      color: AppColors.grey,
                                      align: TextAlign.start),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: Get.height * 0.01,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(
                                        10.0,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: text(
                                          title: doc['title'],
                                          fontSize: Get.width * 0.04,
                                          fontWeight: AppFonts.semiBold,
                                          color: AppColors.black,
                                          align: TextAlign.start),
                                      subtitle: text(
                                          title: doc['body'],
                                          fontSize: Get.width * 0.03,
                                          fontWeight: AppFonts.semiBold,
                                          color: AppColors.grey,
                                          align: TextAlign.start),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: text(
                              title: 'No Notification to display',
                              align: TextAlign.center,
                              color: AppColors.grey,
                              fontSize: Get.width * 0.045,
                              fontWeight: AppFonts.semiBold,
                            ),
                          );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
