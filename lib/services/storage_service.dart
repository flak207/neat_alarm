import 'dart:async';
import 'dart:convert';

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

  StorageService._internal();
  //#endregion

  SharedPreferences? _sharedPreferences;
  final String _alarmsKey = "neat_alarms";
  final String _timersKey = "neat_timers";
  final String _calendarKey = "neat_calendars";

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  List<ClockAlarm> getClockAlarms() {
    String? alarmsString = _sharedPreferences!.getString(_alarmsKey);
    if (alarmsString == null) {
      return [];
    }
    List decodedAlarms = jsonDecode(alarmsString);
    List<ClockAlarm> alarms = decodedAlarms
        .map((decodedAlarm) => ClockAlarm.fromJson(decodedAlarm))
        .toList();
    return alarms;
  }

  void setClockAlarms(List<ClockAlarm> alarms) {
    String encoded = jsonEncode(alarms);
    _sharedPreferences!.setString(_alarmsKey, encoded);
  }

  List<TimerAlarm> getTimers() {
    String? alarmsString = _sharedPreferences!.getString(_timersKey);
    if (alarmsString == null) {
      return [];
    }
    List decodedAlarms = jsonDecode(alarmsString);
    List<TimerAlarm> alarms = decodedAlarms
        .map((decodedAlarm) => TimerAlarm.fromJson(decodedAlarm))
        .toList();
    return alarms;
  }

  void setTimers(List<TimerAlarm> alarms) {
    String encoded = jsonEncode(alarms);
    _sharedPreferences!.setString(_timersKey, encoded);
  }

  List<CalendarAlarm> getCalendarAlarms() {
    String? alarmsString = _sharedPreferences!.getString(_calendarKey);
    if (alarmsString == null) {
      return [];
    }
    List decodedAlarms = jsonDecode(alarmsString);
    List<CalendarAlarm> alarms = decodedAlarms
        .map((decodedAlarm) => CalendarAlarm.fromJson(decodedAlarm))
        .toList();
    return alarms;
  }

  void setCalendarAlarms(List<CalendarAlarm> alarms) {
    String encoded = jsonEncode(alarms);
    _sharedPreferences!.setString(_calendarKey, encoded);
  }

  Future<bool> clearAll() async {
    return await _sharedPreferences!.clear();
  }
}
