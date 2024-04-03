import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
  // final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  // void initState() {
  //   super.initState();
  //   //_scrollController.addListener(() {if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){

  //   //  }})
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: text(
          title: Auth.auth.currentUser!.displayName.toString() ?? 'Unknown',
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
              child: Row(
                children: List.generate(
                  3,
                  (index) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.workSpaceDetail);
                      },
                      child: WorkSpaceContainer(
                        all: false,
                        color1: AppColors.workspaceGradientColor1[index],
                        color2: AppColors.workspaceGradientColor2[index],
                      ),
                    );
                  },
                ),
              ),
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
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return BlocBuilder<homePageTabBarBloc, tabBarStates>(
                      builder: (context, state) {
                        return (state is activeState && state.index == index)
                            ? AnimatedList(
                                key: listKey,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                initialItemCount: 3,
                                itemBuilder: (context, index, animation) {
                                  return TaskTile(
                                      taskName: 'asa',
                                      onRemove: () {
                                        listKey.currentState!.removeItem(
                                          index,
                                          (context, animation) => TaskTile(
                                            index: index,
                                            animation: animation,
                                            onRemove: () {},
                                            taskName: 'sad',
                                          ),
                                        );
                                      },
                                      index: index,
                                      animation: animation);
                                },
                              )
                            : SizedBox();
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
