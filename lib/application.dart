import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_sample/app_strings.dart';
import 'package:firebase_messaging_sample/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();
    _messaging = FirebaseMessaging.instance;

    _messaging.getToken().then((String? token) async {
      print('FCM token = $token');
    });

    /// Returns a Stream that is called when an incoming FCM payload is received whilst
    /// the Flutter instance is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print('Message received (foreground): ${event.notification?.body}');

      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: Strings.notificationChannelId,
              title: event.notification?.title ?? '',
              body: event.notification?.body ?? ''));
    });

    /// Returns a [Stream] that is called when a user presses a notification message displayed
    /// via FCM.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          'Message received on push notif click: ${message.notification?.body}');
    });
  }

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      Fluttertoast.showToast(
          msg: 'Notification Clicked: ${receivedNotification.body}');
    });

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
    );
  }
}
