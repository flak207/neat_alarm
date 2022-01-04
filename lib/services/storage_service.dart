import 'dart:async';
import 'dart:convert';

import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/models/calendar_alarm.dart';
import 'package:neat_alarm/models/clock_alarm.dart';
import 'package:neat_alarm/models/timer_alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  //#region Singletone
  static final StorageService _notificationService = StorageService._internal();

  factory StorageService() {
    return _notificationService;
  }

  StorageService._internal() {
    _typeKeys = {
      ClockAlarm: _alarmsKey,
      TimerAlarm: _timersKey,
      CalendarAlarm: _calendarKey,
    };
    _typeMethods = {
      ClockAlarm: ClockAlarm.fromJson,
      TimerAlarm: TimerAlarm.fromJson,
      CalendarAlarm: CalendarAlarm.fromJson,
    };
  }

  //#endregion

  SharedPreferences? _sharedPreferences;
  final String _alarmsKey = "neat_alarms";
  final String _timersKey = "neat_timers";
  final String _calendarKey = "neat_calendars";
  late final Map<Type, String> _typeKeys;
  late final Map<Type, Function> _typeMethods;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  List<T> getAlarms<T extends Alarm>() {
    String key = _typeKeys[T] ?? _alarmsKey;
    String? alarmsString = _sharedPreferences!.getString(key);
    if (alarmsString == null) {
      return [];
    }

    Function jsonMethod = _typeMethods[T] ?? Alarm.fromJson;
    List decodedAlarms = jsonDecode(alarmsString);
    List<T> alarms = decodedAlarms
        .map((decodedAlarm) => jsonMethod(decodedAlarm) as T)
        .toList();
    return alarms;
  }

  void saveAlarms<T extends Alarm>(List<T> alarms) {
    String key = _typeKeys[T] ?? _alarmsKey;
    String encoded = jsonEncode(alarms);
    _sharedPreferences!.setString(key, encoded);
  }

  Future<bool> clearAll() async {
    return await _sharedPreferences!.clear();
  }
}
