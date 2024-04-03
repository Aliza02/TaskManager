// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDureL9JZsjD82mNguOcivRFmvNF14nKN8',
    appId: '1:326434808011:web:7e0bce7e048fe65c107b4e',
    messagingSenderId: '326434808011',
    projectId: 'taskmanager-6d7c9',
    authDomain: 'taskmanager-6d7c9.firebaseapp.com',
    storageBucket: 'taskmanager-6d7c9.appspot.com',
    measurementId: 'G-GSG1VQFYXP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBRLJujnncIucOOqZtPW7wsN2QAtkf6nYo',
    appId: '1:326434808011:android:f3c8685d68708d02107b4e',
    messagingSenderId: '326434808011',
    projectId: 'taskmanager-6d7c9',
    storageBucket: 'taskmanager-6d7c9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkD58otS5Kg63ek4vR49wbZrHWpVfa9pk',
    appId: '1:326434808011:ios:08ffc52e22d22e98107b4e',
    messagingSenderId: '326434808011',
    projectId: 'taskmanager-6d7c9',
    storageBucket: 'taskmanager-6d7c9.appspot.com',
    iosBundleId: 'com.example.taskmanager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAkD58otS5Kg63ek4vR49wbZrHWpVfa9pk',
    appId: '1:326434808011:ios:4b2ad4004a409189107b4e',
    messagingSenderId: '326434808011',
    projectId: 'taskmanager-6d7c9',
    storageBucket: 'taskmanager-6d7c9.appspot.com',
    iosBundleId: 'com.example.taskmanager.RunnerTests',
  );
}
