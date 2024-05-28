import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<bool> addWorkspace(
      {required String projectName,
      required String projectDescription,
      required List<String> email,
      required String creationDate}) async {
    int projectId = generateProjectNo();

    await firestore.collection('Project').doc(projectId.toString()).set(
      {
        "projectId": projectId,
        "projectName": projectName,
        "projectDescription": projectDescription,
        "email": email,
        "projectCreatedBy": Auth.auth.currentUser!.email,
        "createdOn": creationDate
      },
      SetOptions(merge: true),
    );

    return true;
  }

  Stream<QuerySnapshot> getCreatedProjects() {
    return firestore
        .collection('Project')
        .where('projectCreatedBy', isEqualTo: Auth.auth.currentUser!.email)
        .snapshots();
  }

  Future<bool> addTaskToProject({
    required String task,
    required String description,
    required String date,
    required String time,
    required List<String> members,
  }) async {
    await firestore
        .collection('Tasks')
        .doc(projectController.projectId.string)
        .set({
      'projectId': projectController.projectId.string,
    });

    await firestore
        .collection('Tasks')
        .doc(projectController.projectId.string)
        .collection('projectTasks')
        .doc()
        .set(
      {
        'taskName': task,
        'description': description,
        'deadlineDate': date,
        'deadlineTime': time,
        'Members': members,
        'projectName': projectController.projectName.string,
        'status': 'none',
      },
      SetOptions(merge: true),
    );

    return true;
  }

  Future<QuerySnapshot> getAllProjects() async {
    return await firestore
        .collection('Project')
        .where(Filter.or(
            Filter("email", arrayContains: Auth.auth!.currentUser!.email),
            Filter('projectCreatedBy',
                isEqualTo: Auth.auth!.currentUser!.email)))
        .get();
  }

  Stream<QuerySnapshot> getTasksAsPerStatus({required String taskStatus}) {
    String currentUserEmail =
        FirebaseAuth.instance.currentUser!.email.toString();
    print(taskStatus);
    return firestore
        .collectionGroup('projectTasks')
        .where(
          'Members',
          arrayContains: currentUserEmail,
        )
        .where('status', isEqualTo: taskStatus)
        .snapshots();
  }

  Future<bool> updateTaskStatus(
      {required String taskName, required String changeStatusTo}) async {
    QuerySnapshot snap = await firestore
        .collectionGroup('projectTasks')
        .where('taskName', isEqualTo: taskName)
        .where('Members', arrayContains: Auth.auth.currentUser!.email)
        .get();

    snap.docs[0].reference.update({'status': changeStatusTo});

    print(snap.docs.length);

    return true;
  }

  Future<double?> getProgress({required String id}) async {
    AggregateQuerySnapshot allDocs = await firestore
        .collection('Tasks')
        .doc(id.toString())
        .collection('projectTasks')
        // .where('status', isEqualTo: 'Completed')
        .count()
        .get();
    AggregateQuerySnapshot completed = await firestore
        .collection('Tasks')
        .doc(id)
        .collection('projectTasks')
        .where('status', isEqualTo: 'Completed')
        .count()
        .get();
    print(allDocs.count);
    print(completed.count);
    double percentage = completed.count! / allDocs.count!.toInt();
    return percentage;
  }

  Future<bool> removeMemberToProject({required String email}) async {
    await firestore
        .collection('Project')
        .doc(projectController.projectId.string)
        .update({
      'email': FieldValue.arrayRemove([email])
    });

    return true;
  }

  Future<bool> addMemberToProject({required String email}) async {
    await firestore
        .collection('Project')
        .doc(projectController.projectId.string)
        .update({
      'email': FieldValue.arrayUnion([email])
    });

    return true;
  }

  Stream<DocumentSnapshot> getMembersOfProject() {
    return firestore
        .collection('Project')
        .doc(projectController.projectId.string)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserDetail() {
    return firestore
        .collection('User')
        .where('email', isEqualTo: projectController.projectCreatedBy.value)
        .snapshots();
  }
}
