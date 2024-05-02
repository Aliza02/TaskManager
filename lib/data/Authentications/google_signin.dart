import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskmanager/data/databse/database_functions.dart';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static Future<UserCredential?> googleSignin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential? user =
        await FirebaseAuth.instance.signInWithCredential(credential);

    await Database.firestore
        .collection('User')
        .doc(auth.currentUser!.email.toString())
        .set(
      {
        'email': auth.currentUser!.email.toString(),
        'photoUrl': auth.currentUser!.photoURL,
        'userName': auth.currentUser!.displayName
      },
      SetOptions(merge: true),
    );
    return user;
  }

  static Future<void> GoogleLogout() async {
    await auth.signOut();
  }
}
