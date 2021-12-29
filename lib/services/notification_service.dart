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

  final _channelId = UniqueKey().toString();
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

  void scheduleAlarm(Alarm alarm) async {
    DateTime now = DateTime.now();
    DateTime birthdayDate = alarm.dateTime;
    Duration difference = now.isAfter(birthdayDate)
        ? now.difference(birthdayDate)
        : birthdayDate.difference(now);

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

    await _notificationsPlugin.zonedSchedule(0, alarm.name, alarm.description,
        tz.TZDateTime.now(tz.local).add(difference), platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<Map<Object?, Object?>?> getAllSystemSounds() async {
    Map<Object?, Object?>? data =
        await _platform.invokeMethod<Map<Object?, Object?>>('getAllSounds');
    data?.forEach((key, value) {
      debugPrint('$key : $value');
    });
    return data;
  }

  Future<UriAndroidNotificationSound> getDefaultAlarmSound(String uri) async {
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
