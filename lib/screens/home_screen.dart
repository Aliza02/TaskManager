import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/fonts.dart';
import 'package:taskmanager/constants/icons.dart';
import 'package:taskmanager/constants/labels.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/screens/addWorkspace/add_workspace.dart';
import 'package:taskmanager/screens/workspace_detail_screen.dart';
import 'package:taskmanager/widgets/text.dart';
import 'package:taskmanager/widgets/workspace_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final ScrollController _scrollController = ScrollController();

  void initState() {
    super.initState();
    //_scrollController.addListener(() {if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){

    //  }})
  }

  List<String> bottomNavBarPages = [
    AppRoutes.home,
    AppRoutes.addWorkspce,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
            width: 1,
            color: Colors.grey,
          ),),
        ),
        child: BottomAppBar(
          elevation: 0.0,
          color: AppColors.white,
          height: Get.height * 0.06,
          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.00,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => IconButton(
                onPressed: () {
                  Get.toNamed(bottomNavBarPages[1]);
                },
                icon: Icon(
                  AppIcons.bottomNavBarIcon[index],
                  color: AppColors.grey,
                  size: Get.width * 0.085,
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        title: text(
          title: 'Aliza Aziz',
          fontSize: Get.width * 0.06,
          fontWeight: AppFonts.bold,
          color: AppColors.black,
          align: TextAlign.start,
        ),
        leading: Container(
          margin: EdgeInsets.only(
            left: Get.width * 0.04,
          ),
          child: const CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
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
                        Get.to(() => WorkspaceDetail());
                      },
                      child: WorkSpaceContainer(
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
                  },
                  child: Container(
                      height: Get.height * 0.05,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.02,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Get.width * 0.04,
                        ),
                      ),
                      child: text(
                        title: AppLabels.homePageTabName[index],
                        fontSize: Get.width * 0.04,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.black,
                        align: TextAlign.start,
                      )),
                );
              }),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: List.generate(
                          2,
                          (index) => Expanded(
                            child: InkWell(
                              onTap: () {
                                if (index == 0) {
                                  print('progress');
                                } else {
                                  print('compelterd');
                                }
                              },
                              child: Container(
                                width: Get.width * 0.24,
                                height: Get.height * 0.09,
                                margin: EdgeInsets.only(
                                  right: Get.width * 0.02,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: [
                                    Color(0xFF21B7CA),
                                    AppColors.workspaceGradientColor1[1]
                                  ][index],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text(
                                      title: AppLabels.slidingTitleLabel[index],
                                      fontSize: Get.width * 0.04,
                                      fontWeight: AppFonts.bold,
                                      color: AppColors.white,
                                      align: TextAlign.start,
                                    ),
                                    Icon(
                                      AppIcons.slidingTileIcon[index],
                                      color: AppColors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: Get.height * 0.01,
                          horizontal: Get.width * 0.05,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        child: ListTile(
                          title: text(
                            title: 'Daily Standup Meeting',
                            fontSize: Get.width * 0.04,
                            fontWeight: AppFonts.bold,
                            color: AppColors.black,
                            align: TextAlign.start,
                          ),
                          subtitle: text(
                            title: "10:00 AM- 12:00PM . Ruerth Mobile Design",
                            fontSize: Get.width * 0.03,
                            fontWeight: AppFonts.normal,
                            color: Colors.grey,
                            align: TextAlign.start,
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
