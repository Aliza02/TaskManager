import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Utils/utils.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace/header.dart';

class Comments extends StatelessWidget {
  const Comments({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.arguments;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController commentController = TextEditingController();
    var project = locator<Database>;

    return header(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      title: 'Comments',
                      fontSize: Get.width * 0.05,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.black,
                      align: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    project().addComments(
                      id: id,
                      comment: commentController.text,
                    );
                    commentController.clear();
                  },
                  icon: Icon(Icons.send),
                ),
                hintText: "Write a Comment",
                hintStyle: const TextStyle(
                  color: AppColors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    width * 0.04,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: height * 0.02,
              ),
              child: text(
                title: "All Comments",
                fontSize: width * 0.05,
                fontWeight: AppFonts.bold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            StreamBuilder(
              stream: project().getComments(id: id),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: text(
                        title: "No Comments to display",
                        fontSize: width * 0.045,
                        fontWeight: AppFonts.medium,
                        color: AppColors.black,
                        align: TextAlign.start,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(
                              width * 0.02,
                            ),
                          ),
                          child: InkWell(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        Get.width * 0.02,
                                      ),
                                    ),
                                    elevation: 0.0,
                                    title: text(
                                      title: "Delete Comment",
                                      fontSize: Get.width * 0.065,
                                      fontWeight: AppFonts.bold,
                                      color: AppColors.black,
                                      align: TextAlign.center,
                                    ),
                                    actions: List.generate(
                                      2,
                                      (index) => ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: AppColors
                                              .workspaceGradientColor1[index]
                                              .withOpacity(0.3),
                                        ),
                                        onPressed: () async {
                                          if (index == 0) {
                                            Get.back();
                                          } else {
                                            Get.back();
                                            Utils.showtoast(
                                                "Comment has been deleted");
                                            FirebaseFirestore.instance
                                                .collection('Comments')
                                                .doc(id)
                                                .collection('taskComments')
                                                .doc(doc.id)
                                                .delete();
                                          }
                                        },
                                        child: text(
                                          title: ["Cancel", "Delete"][index],
                                          fontSize: Get.width * 0.04,
                                          fontWeight: AppFonts.semiBold,
                                          color: AppColors.black,
                                          align: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    content: Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                      ),
                                      child: text(
                                        title:
                                            "Are you sure you want to delete this comment?",
                                        fontSize: Get.width * 0.04,
                                        fontWeight: AppFonts.regular,
                                        color: AppColors.grey,
                                        align: TextAlign.start,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: ListTile(
                              title: text(
                                title: doc['author'],
                                fontSize: width * 0.04,
                                fontWeight: AppFonts.medium,
                                color: AppColors.grey,
                                align: TextAlign.start,
                              ),
                              subtitle: text(
                                title: doc['comment'],
                                fontSize: width * 0.045,
                                fontWeight: AppFonts.regular,
                                color: AppColors.black,
                                align: TextAlign.start,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
