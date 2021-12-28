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

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  List<Alarm> getAlarms() {
    // String? birthdaysForDate = _sharedPreferences!
    //     .getString('DateService().formatDateForSharedPrefs(date)');
    // if (birthdaysForDate == null) {
    //   return [];
    // }
    return [
      Alarm('Alarm 1', DateTime.now().add(const Duration(days: 1))),
      Alarm('Alarm 2', DateTime.now().add(const Duration(days: 2)))
    ];
  }
}
