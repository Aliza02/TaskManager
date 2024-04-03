import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
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
    required String email,
  }) async {
    int projectId = generateProjectNo();

    await firestore.collection('Project').doc(projectId.toString()).set(
      {
        "projectId": projectId,
        "projectName": projectName,
        "projectDescription": projectDescription
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('Project')
        .doc(projectId.toString())
        .collection('members')
        .doc()
        .set(
      {
        "email": email,
      },
      SetOptions(
        merge: true,
      ),
    );
    return true;
  }
}
