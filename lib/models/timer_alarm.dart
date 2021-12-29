import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neat_alarm/models/alarm.dart';

class TimerAlarm extends Alarm {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  TimerAlarm(name, dateTime, this.hours, this.minutes, this.seconds,
      {description = '', soundName = '', soundPath = '', isActive = true})
      : super(name, dateTime,
            description: description,
            soundName: soundName,
            soundPath: soundPath,
            isActive: isActive);

  @override
  Widget buildSubtitle(BuildContext context) {
    String subtitle = 'Hours: $hours, Minutes: $minutes, Seconds: $seconds.\n';
    if (isActive) {
      subtitle +=
          'The alarm goes off at: ${DateFormat('HH:mm:ss').format(dateTime)}.';
    } else {
      subtitle += 'The timer is not active.';
    }
    return Text(subtitle);
  }
}
