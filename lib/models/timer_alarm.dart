import 'package:neat_alarm/models/alarm.dart';

class TimerAlarm extends Alarm {
  TimerAlarm(String name, DateTime dateTime,
      {description = '', soundName = '', soundPath = '', isActive = true})
      : super(name, dateTime,
            description: description,
            soundName: soundName,
            soundPath: soundPath,
            isActive: isActive);
}
