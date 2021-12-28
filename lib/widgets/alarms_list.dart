// AlarmsListWidget
import 'package:flutter/material.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/services/storage_service.dart';

class AlarmsList extends StatefulWidget {
  const AlarmsList({Key? key}) : super(key: key);

  @override
  _AlarmsListState createState() => _AlarmsListState();
}

class _AlarmsListState extends State<AlarmsList> {
  List<Alarm> alarms = [];

  @override
  void initState() {
    alarms = StorageService().getAlarms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBarWdg = AppBar(title: const Text(applicationName));

    Widget bodyWdg = Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(alarms[index].name);
          },
        ),
      ),
    ]);

    Scaffold scaffold = Scaffold(appBar: appBarWdg, body: bodyWdg);
    return scaffold;
  }
}
