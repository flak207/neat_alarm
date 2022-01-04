import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const nameKey = "name";
const dateTimeKey = "dateTime";
const descriptionKey = "description";
const soundNameKey = "soundName";
const soundPathKey = "soundPath";
const isActiveKey = "isActive";

class Alarm {
  String name;
  DateTime dateTime;
  String description;
  String soundName;
  String soundPath;
  bool isActive;

  Alarm(this.name, this.dateTime,
      {this.description = '',
      this.soundName = '',
      this.soundPath = '',
      this.isActive = true});

  Alarm.fromJson(Map<String, dynamic> json)
      : name = json[nameKey],
        dateTime = DateTime.tryParse(json[dateTimeKey]) ?? DateTime.now(),
        description = json[descriptionKey],
        soundName = json[soundNameKey],
        soundPath = json[soundPathKey],
        isActive = json[isActiveKey] //.toLowerCase() == 'true'
  ;

  Map<String, dynamic> toJson() => {
        nameKey: name,
        dateTimeKey: dateTime.toIso8601String(),
        descriptionKey: description,
        soundNameKey: soundName,
        soundPathKey: soundPath,
        isActiveKey: isActive
      };

  DateTime getActualDateTime() {
    if (dateTime.isBefore(DateTime.now())) {
      return dateTime.add(const Duration(days: 1));
    }
    return dateTime;
  }

  Widget buildTitle(BuildContext context) => Text(name);

  Widget buildSubtitle(BuildContext context) {
    String subtitle = '$description\n';
    if (isActive) {
      subtitle +=
          'Alarm time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}';
    } else {
      subtitle += 'The alarm is not active.';
    }
    return Text(subtitle);
  }

  Widget buildEditWidget(BuildContext context, Function callback) => Text(name);

  String getFormatedTime() => DateFormat('HH:mm:ss').format(dateTime);

  String getFormatedDate() => DateFormat('yyyy-MM-dd').format(dateTime);

  String getFormatedDateTime() =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}
