import 'package:get/get.dart';
import 'package:taskmanager/routes/routes.dart';
import 'package:taskmanager/screens/addWorkspace/add_workspace.dart';
import 'package:taskmanager/screens/home_screen.dart';
import 'package:taskmanager/screens/workspace/add_member_screen.dart';
import 'package:taskmanager/screens/workspace/add_task.dart';

class Pages {
  static List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addMember,
      page: () => AddMemberScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addTask,
      page: () => AddTask(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addWorkspce,
      page: () => AddWorkspace(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    )
  ];
}
