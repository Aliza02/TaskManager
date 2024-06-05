import 'dart:convert';
import 'dart:io' as io;
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/authorizedbuyersmarketplace/v1.dart'
    as servicecontrol;
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';

import 'package:taskmanager/routes/routes.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var project = locator<Database>;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
//  initialize notification to show on screen

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializedSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializedSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
        project().saveNotifications(
          title: message.notification!.title.toString(),
          body: message.notification!.body.toString(),
        );
      },
    );
  }

// show notification

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'High Importance Channels',
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your channel desc',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );
//for ios
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  // grant permision for notification
  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission: ${settings.authorizationStatus}');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted permission: ${settings.authorizationStatus}');
    } else {
      AppSettings.openAppSettings();
      print("User denied permission");
    }
  }

  // get device token for sending notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    // print(token);
    return token!;
  }

//listen if the token has changes or not
  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      print("Token Refreshed: $event");
    });
  }

// listen to notification
  void firebaseinit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (io.Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotifications(message);
      } else {
        showNotifications(message);
      }

      if (message.notification != null) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
    });
  }

// redirect to screen
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.notification != null) {
      Get.toNamed(
        AppRoutes.notification,
      );
    } else {
      Get.toNamed(AppRoutes.main);
    }
  }

// redirect when app is in backgrounf
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

//when app is in background

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
      project().saveNotifications(
        title: event.notification!.title.toString(),
        body: event.notification!.body.toString(),
      );
    });
  }

  Future<String> getAccessToken() async {
    List<String> scope = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
  }

  Future<void> sendFCM({required String projectName}) async {
    print(serverKey);

    const endPoint =
        "https://fcm.googleapis.com/v1/projects/taskmanager-6d7c9/messages:send";
    final currentToken = await getDeviceToken();
    final Map<String, dynamic> message = {
      'message': {
        'token': currentToken,
        'notification': {
          'title': 'You have deadline for today',
          'body': projectName,
        }
      }
    };

    final response = await http.post(
      Uri.parse(endPoint),
      headers: {
        'Content-Type': "application/json",
        'Authorization': 'Bearer $serverKey',
      },
      body: json.encode(message),
    );

    if (response.statusCode == 200) {
      print('success');
    } else {
      print(response.body);
    }
  }
}
