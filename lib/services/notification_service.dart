import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/alarm.dart';

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

  // final _channelId = UniqueKey().toString();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Init Notification Service
  Future<void> init() async {
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
    var _channelId = UniqueKey().toString();
    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        applicationName,
        fullScreenIntent: true,
        channelDescription: 'channel $_channelId description',
        importance: Importance.high,
        playSound: true,
        priority: Priority.high,
        //sound: uriSound,
        // const RawResourceAndroidNotificationSound('slow_spring_board'),
      ),
    );

    await _notificationsPlugin.zonedSchedule(
        0,
        notificationMessage,
        '',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void scheduleAlarmNotification(Alarm alarm) async {
    var _channelId = UniqueKey().toString();
    DateTime now = DateTime.now();
    DateTime dt = alarm.dateTime;
    Duration difference = dt.difference(now);

    var alarmSound = alarm.soundPath.isEmpty
        ? null
        : UriAndroidNotificationSound(alarm.soundPath);
    var androidDetails = AndroidNotificationDetails(_channelId, applicationName,
        fullScreenIntent: true,
        channelDescription: 'channel $_channelId description',
        importance: Importance.high,
        playSound: true,
        priority: Priority.high,
        sound: alarmSound);

    await _notificationsPlugin.zonedSchedule(
        alarm.hashCode,
        alarm.name,
        alarm.description,
        tz.TZDateTime.now(tz.local).add(difference),
        NotificationDetails(android: androidDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelAlarmNotification(Alarm alarm) async {
    await _notificationsPlugin.cancel(alarm.hashCode);
  }

  void cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<Map<String, String>?> getAllSystemSounds() async {
    Map<Object?, Object?>? data =
        await _platform.invokeMethod<Map<Object?, Object?>>('getAllSounds');
    Map<String, String>? stringMap = data!.cast<String, String>();
    return stringMap;
  }

  Future<UriAndroidNotificationSound> getDefaultAlarmSound() async {
    //String? alarmUri = 'content://media/external/audio/media/26242';
    String? alarmUri = await _platform.invokeMethod<String>('getAlarmUri');
    // content://settings/system/alarm_alert
    final UriAndroidNotificationSound uriSound =
        UriAndroidNotificationSound(alarmUri!);
    return uriSound;
  }

  Future<bool> wasApplicationLaunchedFromNotification() async {
    NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null) {
      return notificationAppLaunchDetails.didNotificationLaunchApp;
    }

    return false;
  }
}
