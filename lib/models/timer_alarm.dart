import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/widgets/timer_alarm_widget.dart';

const hoursKey = "hours";
const minutesKey = "minutes";
const secondsKey = "seconds";

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

  TimerAlarm.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    hours = json[hoursKey];
    minutes = json[minutesKey];
    seconds = json[secondsKey];
  }

  @override
  DateTime getActualDateTime() {
    return DateTime.now()
        .add(Duration(hours: hours, minutes: minutes, seconds: seconds));
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
    baseMap[hoursKey] = hours;
    baseMap[minutesKey] = minutes;
    baseMap[secondsKey] = seconds;
    return baseMap;
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    String subtitle = 'Hours: $hours, Minutes: $minutes, Seconds: $seconds\n';
    if (isActive) {
      subtitle +=
          'Alarm time: ${DateFormat('HH:mm:ss yyyy-MM-dd').format(dateTime)}';
    } else {
      subtitle += 'The timer is not active.';
    }
    return Text(subtitle);
  }

  @override
  Widget buildEditWidget(BuildContext context, Function callback) {
    var retval = TimerAlarmWidget(callback, alarm: this);
    return retval;
  }

  @override
  IconData getActiveIcon() => Icons.timer;

  @override
  IconData getInactiveIcon() => Icons.timer_off;
}
