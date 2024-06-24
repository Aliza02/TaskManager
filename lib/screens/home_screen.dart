import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Utils/utils.dart';
import 'package:taskmanager/controllers/project_controller.dart';
import 'package:taskmanager/data/Authentications/google_signin.dart';
import 'package:taskmanager/bloc/HomePageTaskTabsBloc/bloc.dart';
import 'package:taskmanager/bloc/HomePageTaskTabsBloc/events.dart';
import 'package:taskmanager/bloc/HomePageTaskTabsBloc/states.dart';
import 'package:taskmanager/bloc/userBloc/bloc.dart';
import 'package:taskmanager/bloc/userBloc/events.dart';
import 'package:taskmanager/bloc/userBloc/states.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/constants/labels.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/notification/notification_services.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/widgets/task_tile.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final projectController = Get.put(ProjectController());
  // final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  var project = locator<Database>;
  NotificationServices notification = NotificationServices();
  int colorIndex1 = 0;
  int colorIndex2 = 0;

  @override
  void initState() {
    notification.requestPermission();

    notification.firebaseinit(context);
    notification.setupInteractMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: ValueKey<int>(1),
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: text(
          title: Auth.auth.currentUser!.displayName.toString(),
          fontSize: Get.width * 0.06,
          fontWeight: AppFonts.bold,
          color: AppColors.black,
          align: TextAlign.start,
        ),
        leading: Container(
          margin: EdgeInsets.only(
            left: Get.width * 0.04,
          ),
          child: CircleAvatar(
            child: ClipOval(
                child: CachedNetworkImage(
                    imageUrl: Auth.auth.currentUser!.photoURL.toString())),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<LoginSignUpBloc>(context).add(Logout(false));
            },
            icon: Icon(
              Icons.logout_outlined,
              size: Get.width * 0.09,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              return BlocListener<LoginSignUpBloc, UserStates>(
                listener: (context, state) {
                  if (state is Userloading && state.loading == true) {
                    print(state.loading);
                    Get.snackbar(
                        'Logging out... ', 'Wait a while it is being log out');

                    Get.toNamed(AppRoutes.user);
                  }
                },
                child: Container(),
              );
            }),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: Get.height * 0.02,
                left: Get.width * 0.04,
              ),
              child: text(
                title: 'My Workspace',
                fontSize: Get.width * 0.06,
                fontWeight: AppFonts.bold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder(
                  stream: project().getCreatedProjects(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? snapshot.data!.docs.isNotEmpty &&
                                snapshot.connectionState ==
                                    ConnectionState.active
                            ? Row(
                                children: List.generate(
                                  snapshot.data!.docs.length,
                                  (index) {
                                    DocumentSnapshot snap =
                                        snapshot.data!.docs[index];
                                    projectController.projectCreatedBy.value =
                                        snap['projectCreatedBy'];
                                    projectController.members
                                        .addAll(snap['email']);
                                    if (colorIndex1 == 3 || colorIndex2 == 3) {
                                      colorIndex1 = 0;
                                      colorIndex2 = 0;
                                    }
                                    return InkWell(
                                      onTap: () {
                                        projectController.members.clear();
                                        Get.toNamed(AppRoutes.workSpaceDetail);
                                        projectController.projectId.value =
                                            snap['projectId'];
                                        projectController.projectCreatedBy
                                            .value = snap['projectCreatedBy'];
                                        projectController.projectName.value =
                                            snap['projectName'];
                                        projectController.projectDescription
                                            .value = snap['projectDescription'];
                                        projectController.projectCreationDate
                                            .value = snap['createdOn'];
                                        projectController.members
                                            .addAll(snap['email']);
                                      },
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    AppColors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Get.width * 0.02,
                                                  ),
                                                ),
                                                elevation: 0.0,
                                                title: text(
                                                  title: "Delete Workspace",
                                                  fontSize: Get.width * 0.065,
                                                  fontWeight: AppFonts.bold,
                                                  color: AppColors.black,
                                                  align: TextAlign.center,
                                                ),
                                                actions: List.generate(
                                                  2,
                                                  (index) => ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0.0,
                                                      backgroundColor: AppColors
                                                          .workspaceGradientColor1[
                                                              index]
                                                          .withOpacity(0.3),
                                                    ),
                                                    onPressed: () async {
                                                      if (index == 0) {
                                                        Get.back();
                                                      } else {
                                                        projectController
                                                                .projectId
                                                                .value =
                                                            snap['projectId'];
                                                        Get.back();
                                                        Utils.showtoast(
                                                            "Workspace has been deleted");
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "Project")
                                                            .doc(
                                                                projectController
                                                                    .projectId
                                                                    .value
                                                                    .toString())
                                                            .delete();
                                                      }
                                                    },
                                                    child: text(
                                                      title: [
                                                        "Cancel",
                                                        "Delete"
                                                      ][index],
                                                      fontSize:
                                                          Get.width * 0.04,
                                                      fontWeight:
                                                          AppFonts.semiBold,
                                                      color: AppColors.black,
                                                      align: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                content: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.white,
                                                  ),
                                                  child: text(
                                                    title:
                                                        "Are you sure you want to delete this workspace?",
                                                    fontSize: Get.width * 0.04,
                                                    fontWeight:
                                                        AppFonts.regular,
                                                    color: AppColors.grey,
                                                    align: TextAlign.start,
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: WorkSpaceContainer(
                                        projectId: snap['projectId'].toString(),
                                        projectCreationDate: snap['createdOn'],
                                        membersLength: snap['email'].length,
                                        projectName: snap['projectName'],
                                        all: false,
                                        color1:
                                            AppColors.workspaceGradientColor1[
                                                colorIndex1++],
                                        color2:
                                            AppColors.workspaceGradientColor2[
                                                colorIndex2++],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(
                                height: Get.height * 0.1,
                                child: Center(
                                  child: text(
                                    title: 'No Workspace to display',
                                    align: TextAlign.center,
                                    color: AppColors.grey,
                                    fontSize: Get.width * 0.035,
                                    fontWeight: AppFonts.semiBold,
                                  ),
                                ),
                              )
                        : SizedBox(
                            width: Get.width,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  }),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: Get.height * 0.02,
                left: Get.width * 0.04,
              ),
              child: text(
                title: 'Tasks',
                fontSize: Get.width * 0.055,
                fontWeight: AppFonts.bold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(
                    Get.width * 0.04,
                  ),
                  onLongPress: () {
                    print(index);
                  },
                  onTap: () {
                    BlocProvider.of<homePageTabBarBloc>(context)
                        .add(activeTab(index: index));
                  },
                  child: BlocBuilder<homePageTabBarBloc, tabBarStates>(
                    builder: (context, state) {
                      return Container(
                          height: Get.height * 0.05,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              width: 2,
                              color:
                                  (state is activeState && state.index == index)
                                      ? AppColors.workspaceGradientColor1[index]
                                      : Colors.transparent,
                            )),
                          ),
                          child: text(
                            title: AppLabels.homePageTabName[index],
                            fontSize: Get.width * 0.04,
                            fontWeight: AppFonts.semiBold,
                            color: AppColors.black,
                            align: TextAlign.start,
                          ));
                    },
                  ),
                );
              }),
            ),
            Expanded(
              child: BlocBuilder<homePageTabBarBloc, tabBarStates>(
                builder: (context, state) {
                  return StreamBuilder(
                      stream: (state is activeState && state.index == 0)
                          ? project().getTasksAsPerStatus(taskStatus: 'none')
                          : (state is activeState && state.index == 1)
                              ? project()
                                  .getTasksAsPerStatus(taskStatus: 'inProgress')
                              : project()
                                  .getTasksAsPerStatus(taskStatus: 'Completed'),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return snapshot.data!.docs.isNotEmpty &&
                                  snapshot.connectionState ==
                                      ConnectionState.active
                              ? AnimatedList(
                                  key: listKey,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  initialItemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index, animation) {
                                    DocumentSnapshot snap =
                                        snapshot.data!.docs[index];

                                    return InkWell(
                                      onTap: () {
                                        showBottomSheet(
                                          backgroundColor: AppColors.white,
                                          elevation: 0.0,
                                          enableDrag: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              width * 0.1,
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              width: width,
                                              height: height * 0.55,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.1,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      width * 0.1),
                                                  topLeft: Radius.circular(
                                                      width * 0.1),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.grey,
                                                    blurRadius: 0.3,
                                                    spreadRadius: 0.2,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width * 0.8,
                                                    height: height * 0.01,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.grey
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        width * 0.1,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: height * 0.02,
                                                    ),
                                                    child: text(
                                                      title: "Task Details",
                                                      fontSize: width * 0.06,
                                                      fontWeight: AppFonts.bold,
                                                      color: AppColors.black,
                                                      align: TextAlign.center,
                                                    ),
                                                  ),
                                                  Divider(),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  text(
                                                    title: "Task Name",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                  text(
                                                    title: snap['taskName'],
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.grey,
                                                    align: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  text(
                                                    title: "Description",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                  text(
                                                    title: snap['description'],
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.grey,
                                                    align: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  text(
                                                    title: "Assigned to:",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                  ListView.builder(
                                                    itemCount:
                                                        snap['Members'].length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return text(
                                                        title: snap['Members']
                                                                [index]
                                                            .toString(),
                                                        fontSize: width * 0.04,
                                                        fontWeight:
                                                            AppFonts.medium,
                                                        color: AppColors.grey,
                                                        align: TextAlign.start,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  text(
                                                    title: "Deadline",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.black,
                                                    align: TextAlign.center,
                                                  ),
                                                  text(
                                                    title:
                                                        "${snap['deadlineDate']} | ${snap['deadlineTime']}",
                                                    fontSize: width * 0.04,
                                                    fontWeight: AppFonts.medium,
                                                    color: AppColors.grey,
                                                    align: TextAlign.start,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      vertical: height * 0.02,
                                                    ),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: AppColors
                                                            .workspaceGradientColor1[1],
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: text(
                                                        title: "Close",
                                                        fontSize: width * 0.04,
                                                        fontWeight:
                                                            AppFonts.bold,
                                                        color: AppColors.white,
                                                        align: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: TaskTile(
                                          taskName: snap['taskName'],
                                          id: snap.id,
                                          taskStatus: snap['status'],
                                          deadlineDate: snap['deadlineDate'],
                                          projectName: snap['projectName'],
                                          deadlineTime: snap['deadlineTime'],
                                          enableProgressButton:
                                              (state is activeState &&
                                                      state.index == 1)
                                                  ? false
                                                  : true,
                                          disableSlideButton:
                                              (state is activeState &&
                                                      state.index == 2)
                                                  ? true
                                                  : false,
                                          onRemove: () {
                                            listKey.currentState!.removeItem(
                                              index,
                                              (context, animation) => TaskTile(
                                                index: index,
                                                taskStatus: snap['status'],
                                                animation: animation,
                                                disableSlideButton:
                                                    (state is activeState &&
                                                            state.index == 2)
                                                        ? true
                                                        : false,
                                                enableProgressButton:
                                                    (state is activeState &&
                                                            state.index == 1)
                                                        ? false
                                                        : true,
                                                onRemove: () {},
                                                id: snap.id,
                                                taskName: snap['taskName'],
                                                deadlineDate:
                                                    snap['deadlineDate'],
                                                projectName:
                                                    snap['projectName'],
                                                deadlineTime:
                                                    snap['deadlineTime'],
                                              ),
                                            );
                                          },
                                          index: index,
                                          animation: animation),
                                    );
                                  },
                                )
                              : Center(
                                  child: text(
                                    title: 'No Task to display',
                                    align: TextAlign.center,
                                    color: AppColors.black,
                                    fontSize: Get.width * 0.05,
                                    fontWeight: AppFonts.semiBold,
                                  ),
                                );
                        }
                      });
                  // : SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
