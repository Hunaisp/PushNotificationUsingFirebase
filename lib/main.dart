import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pushnotificationusingfirebase/api/pushnotification_api.dart';
import 'package:pushnotificationusingfirebase/firebase_options.dart';
import 'package:pushnotificationusingfirebase/notification_screen.dart';

import 'home.dart';

// for page navigation
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotificatios();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {NotificationScreen.route: (context) => const NotificationScreen()},
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}


