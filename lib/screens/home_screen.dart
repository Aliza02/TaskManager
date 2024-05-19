import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
  int colorIndex1 = 0;
  int colorIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              margin: EdgeInsets.only(
                top: Get.height * 0.02,
                left: Get.width * 0.04,
              ),
              child: text(
                title: 'Workspace',
                fontSize: Get.width * 0.06,
                fontWeight: AppFonts.bold,
                color: AppColors.black,
                align: TextAlign.start,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder(
                  future: project().getCreatedProjects(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Row(
                            children: List.generate(
                              snapshot.data!.docs.length,
                              (index) {
                                DocumentSnapshot snap =
                                    snapshot.data!.docs[index];
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
                                    projectController.projectName.value =
                                        snap['projectName'];
                                    projectController.projectDescription.value =
                                        snap['projectDescription'];
                                    projectController.members
                                        .addAll(snap['email']);
                                  },
                                  child: WorkSpaceContainer(
                                    projectName: snap['projectName'],
                                    all: false,
                                    color1: AppColors
                                        .workspaceGradientColor1[colorIndex1++],
                                    color2: AppColors
                                        .workspaceGradientColor2[colorIndex2++],
                                  ),
                                );
                              },
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
                    // print(tabName[index]);
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
                          ? project().getAssignedTasks()
                          : (state is activeState && state.index == 1)
                              ? project().getInProgressTasks()
                              : project().getCompletedTasks(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return snapshot.data!.docs.length != 0
                              ? AnimatedList(
                                  key: listKey,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  initialItemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index, animation) {
                                    DocumentSnapshot snap =
                                        snapshot.data!.docs[index];

                                    return TaskTile(
                                        taskName: snap['taskName'],
                                        deadlineDate: snap['deadlineDate'],
                                        projectName: snap['projectName'],
                                        deadlineTime: snap['deadlineTime'],
                                        onRemove: () {
                                          listKey.currentState!.removeItem(
                                            index,
                                            (context, animation) => TaskTile(
                                              index: index,
                                              animation: animation,
                                              onRemove: () {},
                                              taskName: snap['taskName'],
                                              deadlineDate:
                                                  snap['deadlineDate'],
                                              projectName: snap['projectName'],
                                              deadlineTime:
                                                  snap['deadlineTime'],
                                            ),
                                          );
                                        },
                                        index: index,
                                        animation: animation);
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
