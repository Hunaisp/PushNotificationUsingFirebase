import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const route = '/notification-screen';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments as RemoteMessage?;
    return Scaffold(backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message!.notification!.title.toString()),SizedBox(height: 30,),
          Text(message.notification!.body.toString()),SizedBox(height: 30,),
          Text(message.data.toString()),
        ],
      ),
    );
  }
}
