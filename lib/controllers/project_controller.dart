import 'package:get/get.dart';

class ProjectController extends GetxController {
  RxInt projectId = 0.obs;
  RxString projectName = ''.obs;
  RxString projectDescription = ''.obs;
  RxList members = [].obs;
}
