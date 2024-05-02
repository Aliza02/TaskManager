import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:taskmanager/controllers/project_controller.dart';
import 'package:taskmanager/data/Authentications/google_signin.dart';

class Database {
  final projectController = Get.put(ProjectController());
  Database() {
    print('sda');
  }
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _projectId = 0;
  int generateProjectNo() {
    _projectId = Random().nextInt(560000);
    return _projectId;
  }

  Future<bool> addWorkspace({
    required String projectName,
    required String projectDescription,
    required List<String> email,
  }) async {
    int projectId = generateProjectNo();

    await firestore.collection('Project').doc(projectId.toString()).set(
      {
        "projectId": projectId,
        "projectName": projectName,
        "projectDescription": projectDescription,
        "email": email,
        "projectCreatedBy": Auth.auth.currentUser!.email,
      },
      SetOptions(merge: true),
    );

    return true;
  }

  Future<QuerySnapshot> getCreatedProjects() async {
    QuerySnapshot snap = await firestore
        .collection('Project')
        .where('projectCreatedBy', isEqualTo: Auth.auth.currentUser!.email)
        .get();
    return snap;
  }

  Future<bool> addTaskToProject({
    required String task,
    required String description,
    required String date,
    required String time,
    required List<String> members,
  }) async {
    await firestore
        .collection('Project')
        .doc(projectController.projectId.string)
        .collection('Tasks')
        .doc(task)
        .set({
      'taskName': task,
      'description': description,
      'deadlineDate': date,
      'deadlineTime': time,
      'Members': members,
      'status': 'none',
    }, SetOptions(merge: true));

    return true;
  }

  Future<DocumentSnapshot> getProject() async {
    return await firestore
        .collection('Project')
        .doc(projectController.projectId.string)
        .get();
  }

  Future<QuerySnapshot> getAllProjects() async {
    return await firestore.collection('Project').get();
  }

  Future<void> getAssignedTasks() async {
    await firestore
        .collection('Project')
        .where('email', arrayContains: Auth.auth.currentUser!.email)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                print(element.id);
                
              })
            });
    // return null;
  }
}
