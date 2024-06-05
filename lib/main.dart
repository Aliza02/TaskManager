import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:taskmanager/data/Authentications/google_signin.dart';
import 'package:taskmanager/firebase_options.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/routes/pages.dart';
import 'package:taskmanager/routes/routes.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  setup();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessaging);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessaging(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void firebaseinit() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  void initState() {
    super.initState();
    firebaseinit();
  }
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      getPages: Pages.pages,
      initialRoute:
          Auth.auth.currentUser == null ? AppRoutes.user : AppRoutes.main,
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
          )),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
