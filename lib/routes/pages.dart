import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:taskmanager/bloc/HomePageTaskTabsBloc/bloc.dart';
import 'package:taskmanager/bloc/TaskBloc/task_bloc.dart';
import 'package:taskmanager/bloc/addMemberToProject/addMemberBloc.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_bloc.dart';
import 'package:taskmanager/bloc/bottomNavBarBloc/bloc.dart';
import 'package:taskmanager/bloc/memberBloc/member_bloc.dart';
import 'package:taskmanager/bloc/removeMemberFromProjectBloc/removeMember_bloc.dart';
import 'package:taskmanager/bloc/userBloc/bloc.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/screens/Signup-in/user.dart';
import 'package:taskmanager/screens/addWorkspace/add_workspace.dart';
import 'package:taskmanager/screens/comments/comments_screen.dart';
import 'package:taskmanager/screens/home_screen.dart';
import 'package:taskmanager/screens/main_screen.dart';
import 'package:taskmanager/screens/notification/notification.dart';
import 'package:taskmanager/screens/workspace/add_member_screen.dart';
import 'package:taskmanager/screens/workspace/add_task.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart'
    as GetTrasition;
import 'package:taskmanager/screens/workspace/all_workspace.dart';
import 'package:taskmanager/screens/workspace_detail_screen.dart';

class Pages {
  static List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.main,
      page: () => MultiBlocProvider(
        providers: [
          BlocProvider<NavBarBloc>(
            create: (context) => NavBarBloc(),
          ),
          BlocProvider<homePageTabBarBloc>(
            create: (context) => homePageTabBarBloc(),
          ),
          BlocProvider<LoginSignUpBloc>(
            create: (context) => LoginSignUpBloc(),
          ),
          BlocProvider<ProjectBloc>(
            create: (context) => ProjectBloc(),
          ),
          BlocProvider<MemberBloc>(
            create: (context) => MemberBloc(),
          ),
        ],
        child: MainScreen(),
      ),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.user,
      page: () => BlocProvider(
        create: (context) => LoginSignUpBloc(),
        child: User(),
      ),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addMember,
      page: () => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddMemberToProjectBloc(),
          ),
          BlocProvider(
            create: (context) => RemoveMemberFromProjectBloc(),
          ),
        ],
        child: AddMemberScreen(),
      ),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addTask,
      page: () => MultiBlocProvider(
        providers: [
          BlocProvider<MemberBloc>(
            create: (context) => MemberBloc(),
          ),
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(),
          ),
        ],
        child: AddTask(),
      ),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addWorkspce,
      page: () => AddWorkspace(),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => Notifications(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.workSpaceDetail,
      page: () => WorkspaceDetail(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.allWorkspace,
      page: () => AllWorkspace(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.comment,
      page: () => Comments(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
