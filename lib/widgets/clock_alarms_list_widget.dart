import 'package:flutter/material.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/services/storage_service.dart';
import 'package:neat_alarm/widgets/clock_alarm_widget.dart';

class ClockAlarmsListWidget extends StatefulWidget {
  const ClockAlarmsListWidget({Key? key}) : super(key: key);

  @override
  _ClockAlarmsListWidgetState createState() => _ClockAlarmsListWidgetState();
}

class _ClockAlarmsListWidgetState extends State<ClockAlarmsListWidget> {
  List<Alarm> _alarms = [];

  @override
  void initState() {
    _alarms = StorageService().getAlarms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBarWdg = AppBar(
      title: const Text(alarmsTitle),
      backgroundColor: appBackground,
      foregroundColor: appForeground,
      shadowColor: appForeground,
      toolbarHeight: 50,
    );

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

    var addBtn = FloatingActionButton(
      backgroundColor: appBackground,
      foregroundColor: appForeground,
      child: const Icon(Icons.add),
      onPressed: () => _startAddNewAlarm(context),
    );

    Scaffold scaffold = Scaffold(
      appBar: appBarWdg,
      backgroundColor: widgetBackground,
      body: bodyWdg,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: addBtn,
    );
    return scaffold;
  }

  void _startAddNewAlarm(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: ClockAlarmWidget(_addNewAlarm),
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
