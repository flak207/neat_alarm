import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const MethodChannel platform = MethodChannel('kea.dev/neat_alarm');

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    debugPrint('from background');
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  tz.initializeTimeZones();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    //selectedNotificationPayload = payload;
    //selectNotificationSubject.add(payload);
  });

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static String channelId = UniqueKey().toString();
  static const String applicationName = "Neat 1";

  @override
  Widget build(BuildContext context) {
    AppBar appBarWdg = AppBar(title: const Text('Neat Alarm'));

    var btnAddAlarm = ElevatedButton(
        child: const Text(
          'Add New Alarm 5',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () async {
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          debugPrint('Clicked $formattedDate');

          var lines = <String>['line <b>1</b>', 'line <i>2</i>'];
          var inboxStyleInformation = InboxStyleInformation(lines,
              htmlFormatLines: true,
              contentTitle: 'overridden <b>inbox</b> context title',
              htmlFormatContentTitle: true,
              summaryText: 'summary <i>text</i>',
              htmlFormatSummaryText: true);

          String? alarmUri = await platform.invokeMethod<String>('getAlarmUri');
          debugPrint('URI!!!!!!! $alarmUri');
          // content://settings/system/alarm_alert
          Map<Object?, Object?>? data = await platform
              .invokeMethod<Map<Object?, Object?>>('getAllSounds');
          //Map<String, String>? fullMap = Map<String, String>.from(data);
          // debugPrint('$data');
          data?.forEach((key, value) {
            debugPrint('$key : $value');
          });

          alarmUri = 'content://media/external/audio/media/26242';
          final UriAndroidNotificationSound uriSound =
              UriAndroidNotificationSound(alarmUri); //!);

          var platformChannelSpecifics = NotificationDetails(
            android: AndroidNotificationDetails(
              channelId,
              applicationName,
              channelDescription: 'Description 2',
              importance: Importance.max,
              playSound: true,
              priority: Priority.high,
              sound: uriSound,
              //const RawResourceAndroidNotificationSound('mari'),
              styleInformation: inboxStyleInformation,
            ),
          );

          // await flutterLocalNotificationsPlugin.show(
          //     12345,
          //     "A Notification From My Application",
          //     "This notification was sent using Flutter Local Notifcations Package",
          //     platformChannelSpecifics,
          //     payload: 'data');

          await flutterLocalNotificationsPlugin.zonedSchedule(
              12345,
              "A Notification From My App",
              "This notification is brought to you by Local Notifcations Package",
              tz.TZDateTime.now(tz.local).add(const Duration(hours: 9)),
              platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);
        });
    var btnContainer = Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: btnAddAlarm);
    Widget bodyWdg = Column(children: [btnContainer]);

    Scaffold scaffold = Scaffold(appBar: appBarWdg, body: bodyWdg);
    // MaterialApp, CupertinoApp, WidgetsApp
    MaterialApp baseApp = MaterialApp(home: scaffold);
    return baseApp;
  }
}
