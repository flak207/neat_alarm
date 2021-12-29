import 'package:flutter/material.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/timer_alarm.dart';
import 'package:neat_alarm/services/notification_service.dart';
import 'package:neat_alarm/services/storage_service.dart';
import 'package:neat_alarm/widgets/new_timer_alarm_widget.dart';

class TimerAlarmsListWidget extends StatefulWidget {
  const TimerAlarmsListWidget({Key? key}) : super(key: key);

  @override
  _TimerAlarmsListWidgetState createState() => _TimerAlarmsListWidgetState();
}

class _TimerAlarmsListWidgetState extends State<TimerAlarmsListWidget> {
  List<TimerAlarm> _alarms = [];

  @override
  void initState() {
    _alarms = []; //StorageService().getAlarms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBarWdg = AppBar(
      title: const Text(timersTitle),
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
        //isDismissible: false,
        builder: (BuildContext context) {
          // return GestureDetector(
          //   onTap: () {},
          //   child: NewTimerAlarmWidget(_addNewAlarm),
          //   behavior: HitTestBehavior.opaque,
          // );
          return NewTimerAlarmWidget(_addNewAlarm);
        },
        isScrollControlled: true,
        backgroundColor: appBackground);
  }

  void _addNewAlarm(
      String alarmName, String alarmDescription, DateTime alarmDate) {
    final newAlarm =
        TimerAlarm(alarmName, alarmDate, description: alarmDescription);

    setState(() {
      _alarms.add(newAlarm);
    });
    StorageService().setAlarms(_alarms);
    NotificationService().scheduleAlarm(newAlarm);
  }
}
