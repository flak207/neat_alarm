// AlarmsListWidget
import 'package:flutter/material.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/services/storage_service.dart';
import 'package:neat_alarm/widgets/new_alarm.dart';

class AlarmsList extends StatefulWidget {
  const AlarmsList({Key? key}) : super(key: key);

  @override
  _AlarmsListState createState() => _AlarmsListState();
}

class _AlarmsListState extends State<AlarmsList> {
  List<Alarm> _alarms = [];

  @override
  void initState() {
    _alarms = StorageService().getAlarms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBarWdg = AppBar(title: const Text(applicationName));

    Widget bodyWdg = Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: _alarms.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(_alarms[index].name);
          },
        ),
      ),
    ]);

    Scaffold scaffold = Scaffold(
        appBar: appBarWdg,
        body: bodyWdg,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _startAddNewAlarm(context),
        ));
    return scaffold;
  }

  void _startAddNewAlarm(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewAlarm(_addNewAlarm),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewAlarm(
      String alarmName, String alarmDescription, DateTime alarmDate) {
    final newAlarm = Alarm(alarmName, alarmDate);
    setState(() {
      _alarms.add(newAlarm);
    });
    StorageService().setAlarms(_alarms);
  }
}
