import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    debugPrint('from background');
  }

  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');
  // const InitializationSettings initializationSettings =
  //     InitializationSettings();
  // // InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String? payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  //   //selectedNotificationPayload = payload;
  //   //selectNotificationSubject.add(payload);
  // });

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    AppBar appBarWdg = AppBar(title: const Text('Neat Alarm'));

    var button = ElevatedButton(
        child: const Text('Set Alarm', style: TextStyle(fontSize: 22)),
        onPressed: () {
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
          debugPrint('Clicked $formattedDate');
        });
    Widget bodyWdg = Center(child: button);

    Scaffold scaffold = Scaffold(appBar: appBarWdg, body: bodyWdg);
    // MaterialApp, CupertinoApp, WidgetsApp
    MaterialApp baseApp = MaterialApp(home: scaffold);
    return baseApp;
  }
}
