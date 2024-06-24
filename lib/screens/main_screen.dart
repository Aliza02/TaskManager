import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:taskmanager/bloc/bottomNavBarBloc/bloc.dart';
import 'package:taskmanager/bloc/bottomNavBarBloc/events.dart';
import 'package:taskmanager/bloc/bottomNavBarBloc/states.dart';
import 'package:taskmanager/constants/colors.dart';
import 'package:taskmanager/constants/icons.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/screens/addWorkspace/add_workspace.dart';
import 'package:taskmanager/screens/home_screen.dart';
import 'package:taskmanager/screens/notification/notification.dart';
import 'package:taskmanager/screens/workspace/all_workspace.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var project = locator<Database>;

  @override
  void initState() {
    super.initState();
    project().sendDeadlineReminder();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomNavBarPages = [
      const HomeScreen(),
      const AddWorkspace(),
      const AllWorkspace(),
      const Notifications(),
    ];
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
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
              4,
              (index) => IconButton(
                onPressed: () {
                  BlocProvider.of<NavBarBloc>(context)
                      .add(currentPage(index: index));
                  // noti.sendFCM();
                },
                icon: BlocBuilder<NavBarBloc, NavBarStates>(
                  builder: (context, state) {
                    return Icon(
                      AppIcons.bottomNavBarIcon[index],
                      color: (state is pageNavigate && state.index == index)
                          ? AppColors.black
                          : AppColors.grey,
                      size: Get.width * 0.085,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<NavBarBloc, NavBarStates>(
          bloc: BlocProvider.of<NavBarBloc>(context),
          builder: (context, states) {
            if (states is pageNavigate) {
              return AnimatedSwitcher(
                  // switchOutCurve: Threshold(0),
                  // switchInCurve: Curves.linear,
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  duration: Duration(milliseconds: 250),
                  child: bottomNavBarPages[states.index]);
            } else {
              return SizedBox();
            }
          }),
    );
  }
}
