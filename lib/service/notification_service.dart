import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;

import '../constants.dart';

class NotificationService {
  //#region Singletone
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();
  //#endregion

  static const MethodChannel _platform = MethodChannel('kea.dev/neat_alarm');

  final _channelId = UniqueKey().toString();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Init Notification Service
  Future<void> init() async {
    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    //     await _notificationsPlugin.getNotificationAppLaunchDetails();
    // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    //   debugPrint('from background');
    // }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  // Callback for notification tapped
  void selectNotification(String? payload) async {
    debugPrint('Notification payload: $payload');
  }

  void showNotification(String notificationMessage) async {
    var lines = <String>['Message: <b>$notificationMessage</b>'];
    var inboxStyleInformation = InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);

    debugPrint('AllSounds !!!!!!!');
    Map<Object?, Object?>? data =
        await _platform.invokeMethod<Map<Object?, Object?>>('getAllSounds');
    data?.forEach((key, value) {
      debugPrint('$key : $value');
    });

    //String? alarmUri = 'content://media/external/audio/media/26242';
    String? alarmUri = await _platform.invokeMethod<String>('getAlarmUri');
    debugPrint('URI!!!!!!! $alarmUri');
    // content://settings/system/alarm_alert
    final UriAndroidNotificationSound uriSound =
        UriAndroidNotificationSound(alarmUri!);

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
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

    await _notificationsPlugin.zonedSchedule(
        12345,
        "A Notification From My App",
        "This notification is brought to you by Local Notifcations Package",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

// await flutterLocalNotificationsPlugin.show(
    //     12345,
    //     "A Notification From My Application",
    //     "This notification was sent using Flutter Local Notifcations Package",
    //     platformChannelSpecifics,
    //     payload: 'data');

    // await _notificationsPlugin.show(
    //     12345,
    //     applicationName,
    //     notificationMessage,
    //     NotificationDetails(
    //         android: AndroidNotificationDetails(_channelId, applicationName)),
    //     payload: 'info');
  }
}
