import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:taskmanager/data/Authentications/google_signin.dart';
import 'package:taskmanager/firebase_options.dart';
import 'package:taskmanager/injection/database.dart';
import 'package:taskmanager/routes/pages.dart';
import 'package:taskmanager/routes/routes.dart';

void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      getPages: Pages.pages,
      initialRoute: Auth.auth.currentUser==null? AppRoutes.user: AppRoutes.main,
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
