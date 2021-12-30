import 'package:neat_alarm/models/alarm.dart';

const isRecurringKey = "isRecurring";

class CalendarAlarm extends Alarm {
  bool isRecurring = false;

  CalendarAlarm(name, dateTime, this.isRecurring,
      {description = '', soundName = '', soundPath = '', isActive = true})
      : super(name, dateTime,
            description: description,
            soundName: soundName,
            soundPath: soundPath,
            isActive: isActive);

  CalendarAlarm.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    isRecurring = json[isRecurringKey];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> baseMap = {
      nameKey: name,
      dateTimeKey: dateTime.toIso8601String(),
      descriptionKey: description,
      soundNameKey: soundName,
      soundPathKey: soundPath,
      isActiveKey: isActive
    };
    baseMap[isRecurringKey] = isRecurring;
    return baseMap;
  }
}
