import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pushnotificationusingfirebase/main.dart';
import 'package:pushnotificationusingfirebase/notification_screen.dart';

// go to firebase selecte encage option
// select messaging and paste FCMToken and paste it and press add button
// each user
class FirebaseApi {
  final _firebasemessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage([RemoteMessage? message]) async {
    print('Title:${message?.notification?.title}');
    print('Body:${message?.notification?.body}');
    print('Payload:${message?.data}');
  }

  Future<void> initNotificatios() async {
    await _firebasemessaging.requestPermission();
    final FCMToken = await _firebasemessaging.getToken();
    print("Token:$FCMToken");
    //for pushing notification
    initPushNotification();
  }

  // handle notification
  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    navigatorKey.currentState
        ?.pushNamed(NotificationScreen.route, arguments: message);
  }

//this is importent in notification:- this will show only at the time of closing the app
  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(
        (message) => handleBackgroundMessage(message));
    //for local notification
    FirebaseMessaging.onMessage.listen((message) {
      final notifications = message.notification;
      if (notifications == null) return;
      //for adding icon go to android-app-src-main-res paste that image in drawable and drawable-v21 folder
      _localNotifications.show(
          notifications.hashCode,
          notifications.title,
          notifications.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                androidChannel.id, androidChannel.name,
                channelDescription: androidChannel.description,
                icon: '@drawable/ic_launcher'),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

// for adding app local notification:-this notification shows at the time of app is open and at the time of close(here we want to run flutter pub add  flutter_local_notifications)
  //add some codes in android manifest xml file:-
  // <meta-data
  //             android:name="com.google.firebase.messaging.default_notification_channel_id"
  //             android:value="high_importance_channel"></meta-data>
  final androidChannel = AndroidNotificationChannel(
      'high_importance_channel', 'High_Importance_Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.defaultImportance);
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    const android = AndroidInitializationSettings('app_icon');
    const settings = InitializationSettings(android: android);

    final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
    await localNotifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        final message = RemoteMessage.fromMap(jsonDecode(payload));
        handleMessage(message);
      },
    );
  }

}
