import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_sample/app_strings.dart';
import 'package:firebase_messaging_sample/application.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// Enabling background messages on Firebase Messaging causes hot reload/
  /// hot restart to break.
  ///
  /// https://github.com/FirebaseExtended/flutterfire/issues/4316
  /// Comment this line while debugging to use hot restart/ hot reload
  ///
  /// Set a message handler function which is called when the app is in the
  /// background or terminated.
  ///
  /// This provided handler must be a top-level function
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: Strings.notificationChannelId,
        channelName: Strings.notificationChannelName,
        channelDescription: Strings.notificationChannelDesc,
        playSound: true,
        soundSource: 'resource://raw/res_pink_panther',
        importance: NotificationImportance.High,
      )
    ],
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience

      AwesomeNotifications().requestPermissionToSendNotifications(
        channelKey: Strings.notificationChannelId,
      );
    }
  });

  runApp(Application());
}

Future<void> _messageHandler(RemoteMessage message) async {
  print("background message ${message.notification?.body ?? ''}");
}
