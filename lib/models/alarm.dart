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
}
