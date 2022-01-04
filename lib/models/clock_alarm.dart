import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/widgets/clock_alarm_widget.dart';

const isRecurringKey = "isRecurring";

class ClockAlarm extends Alarm {
  bool isRecurring = false;

  ClockAlarm(name, dateTime, this.isRecurring,
      {description = '', soundName = '', soundPath = '', isActive = true})
      : super(name, dateTime,
            description: description,
            soundName: soundName,
            soundPath: soundPath,
            isActive: isActive);

  ClockAlarm.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    isRecurring = json[isRecurringKey] ?? false;
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

  @override
  Widget buildSubtitle(BuildContext context) {
    String subtitle = '${DateFormat('HH:mm:ss').format(dateTime)}\n';
    if (isActive) {
      subtitle +=
          'Alarm time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}';
    } else {
      subtitle += 'The alarm is not active.';
    }
    return Text(subtitle);
  }

  @override
  Widget buildEditWidget(BuildContext context, Function callback) {
    var retval = ClockAlarmWidget(callback, alarm: this);
    return retval;
  }
}
