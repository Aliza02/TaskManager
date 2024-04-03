import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static Future<UserCredential?> googleSignin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential? user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return user;
  }

  static Future<void> GoogleLogout() async {
    await auth.signOut();
  }
}
