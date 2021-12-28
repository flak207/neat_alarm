import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:neat_alarm/models/alarm.dart';

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

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  List<Alarm> getAlarms() {
    // return [
    //   Alarm('Alarm 1', DateTime.now().add(const Duration(days: 1))),
    //   Alarm('Alarm 2', DateTime.now().add(const Duration(days: 2)))
    // ];

    String? alarmsString = _sharedPreferences!.getString(_alarmsKey);
    if (alarmsString == null) {
      return [];
    }
    List decodedAlarms = jsonDecode(alarmsString);
    List<Alarm> alarms = decodedAlarms
        .map((decodedAlarm) => Alarm.fromJson(decodedAlarm))
        .toList();
    return alarms;
  }

  void setAlarms(List<Alarm> alarms) {
    String encoded = jsonEncode(alarms);
    _sharedPreferences!.setString(_alarmsKey, encoded);
  }

  Future<bool> clearAll() async {
    return await _sharedPreferences!.clear();
  }
}
