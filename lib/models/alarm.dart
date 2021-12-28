class Alarm {
  final String name;
  final DateTime dateTime;
  final String description;
  // final String soundPath;
  final bool isActive;

  Alarm(this.name, this.dateTime,
      {this.description = '', this.isActive = true});
}
