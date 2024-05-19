import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  RxInt projectId = 0.obs;
  RxString projectName = ''.obs;
  RxString projectDescription = ''.obs;
  RxList members = [].obs;

  RxList taskName = [].obs;
  RxList projectname = [].obs;
  RxList taskDeadlineDate = [].obs;
  RxList taskDeadlineTime = [].obs;

  // assigned task

  // List<QuerySnapshot> snap = <QuerySnapshot>[].obs;
}
