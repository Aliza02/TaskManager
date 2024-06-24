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
        project().saveNotifications(
          title: message.notification!.title.toString(),
          body: message.notification!.body.toString(),
        );
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
    });
  }

  // Future<String> getAccessToken() async {
  //   final serviceAccountJson = {
  //     "type": "service_account",
  //     "project_id": "taskmanager-6d7c9",
  //     "private_key_id": "614b064ca2c3e29d89fbb8300977cd8735859c98",
  //     "private_key":
  //         "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCNl1+aArIJHoDy\nKwm9p3NwDpQzvcXE6UwpT2LPUBIRctefTNxnGAufQb1UAprGQnQ1T6d/zRWGzlIh\nAYcADA5veq6IjojYio/gC0CzyjlbF6jiLvr/y1Aow+Xhoj/uCfi1avXysnaV6KYV\nldFFjKLSAjRVsJHRb5Rw/xuk7lLxtKGQZRqIwd7a6Zv31X5liOaABn04LrDBuwJa\nLpCDnfBkTJVZnspxMv0yl+wzkB+W1HdtJgtCHvRpIFlwoah28Wlz2v68TJhx4s86\nWQ/Li/CXXpffCx31TF9EKG2rzTOpRo1tntCrKJTaeQ+j/Z5aqsHDwTMhgDIoj7Wz\nynjd7XWJAgMBAAECggEAJnLvKo7F0tUeNeS7Ae3JWqoS05QactTZcjRVBC/doDBb\n3i3MghBVA5uh8oC8j8726I0nUnyZ9l/rjHvyMXCUsPATGhD+lzLVTAUyPkBRX+um\nWDlivnhy3YcI00Mwcg7yIy2W+R8+NYoWI7FpwSWmBzpDBOvsRP+0QxT7aEexbWH0\nv0y5qGredKueKU6lBnJJDA1uajVG9wMjdkUi7erqLFimU+KJVzr+v/+O3KfPhBNQ\nEPZ/NZKjep7gdGp9ZR03q/mgvz74BE0YNoGeeThwYlJZt4rw+C47rTNmAzATwlJd\nEDo+Y8Y9HxIx+PgsNw1lyAo0/QNixPPKCU/2h69oMwKBgQDAlRiXyHSYdKUGZ3N0\nhRWO2ZjY5vg9GqUC18G8jzgKTZS0KoOAfGeyveL7jtXCGO3kU7p6YcIxDPYtut/h\nWsvRmqJElZaZIhJo4EVmKxooFtfDdQNUEoKXnTR4FJ5tdxS7Cx7aoUYZ/8dI1wc/\nggBAzLeQd7NmCR/62Sjv7gi8GwKBgQC8N6wn/r8A4lYQcpoXcLu79xd2cvp25kUY\nLkllK0HFGbwFHBPQDh75mUaeDpVodj5DOws6ZMjHOc7/m+h9eO9JRpP+7ydNkZR6\nwVzJzP7gIfM56kxAzb9YgjD/lje3FDyEw0bWUAQkVt37B5fLbVp53fGEz8GYPS0g\n0dAmusVnKwKBgD/TKgtjzACa5/ZvYrxDPxnQ0+9O3QajRfzjNLohXRlNDPOJA3wZ\nvuRmOkvU0tM5H96EQVE+BPXsrcoKHRi61sHo1c6VJQwrVp6bdWSe9FRE/c0xgqDi\nYZWN7E2/x6HPzXcQAHHE8U68jnd9jFFn7F2Ne2jNww8WBxtDzWV3Jj3xAoGAUoiP\nI1Kf6wFVAA1g6Jp0mC33yecNUYoUDlBtusFHK+jm+86eGYO3rXe68aAvgAkpsE15\n1PdQ25vL22ZAgpS/SQB78TRppagK1fFogM01jo8UmvbUzS3rlCIy3kC+2bcz+nuu\n2ldoGY9F88gWlguzuvDJ8ZUwrVNWMKgQgIsx+NUCgYB604a7jKBnFtqqdSB86txT\nE+8eFvc5xWMWpVvqUzqRZKul4IkwTi4YOLBIHBEQRgFAnl00lIuiOqzxKAaIrdMz\nTw4WdtC65DndPLHHiRn0PhgHA1Uov3CkSfM18L85y/SIVbwCjMhP/oy9es+1hnwA\nReY9hcwRxzRAB9V97WIKTg==\n-----END PRIVATE KEY-----\n",
  //     "client_email":
  //         "firebase-adminsdk-mqcrb@taskmanager-6d7c9.iam.gserviceaccount.com",
  //     "client_id": "113194932479080135233",
  //     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //     "token_uri": "https://oauth2.googleapis.com/token",
  //     "auth_provider_x509_cert_url":
  //         "https://www.googleapis.com/oauth2/v1/certs",
  //     "client_x509_cert_url":
  //         "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mqcrb%40taskmanager-6d7c9.iam.gserviceaccount.com",
  //     "universe_domain": "googleapis.com"
  //   };

  //   List<String> scope = [
  //     "https://www.googleapis.com/auth/userinfo.email",
  //     "https://www.googleapis.com/auth/firebase.database",
  //     "https://www.googleapis.com/auth/firebase.messaging",
  //   ];

  //   http.Client client = await auth.clientViaServiceAccount(
  //     auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
  //     scope,
  //   );

  //   auth.AccessCredentials credentials =
  //       await auth.obtainAccessCredentialsViaServiceAccount(
  //     auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
  //     scope,
  //     client,
  //   );
  //   client.close();
  //   return credentials.accessToken.data;
  // }

  // Future<void> sendFCM({required String projectName}) async {
  //   final String serverKey = await getAccessToken();
  //   print(serverKey);

  //   const endPoint =
  //       "https://fcm.googleapis.com/v1/projects/taskmanager-6d7c9/messages:send";
  //   final currentToken = await getDeviceToken();
  //   final Map<String, dynamic> message = {
  //     'message': {
  //       'token': currentToken,
  //       'notification': {
  //         'title': 'You have deadline for today',
  //         'body': projectName,
  //       }
  //     }
  //   };

  //   final response = await http.post(
  //     Uri.parse(endPoint),
  //     headers: {
  //       'Content-Type': "application/json",
  //       'Authorization': 'Bearer $serverKey',
  //     },
  //     body: json.encode(message),
  //   );

  //   if (response.statusCode == 200) {
  //     print('success');
  //   } else {
  //     print(response.body);
  //   }
  // }
}
