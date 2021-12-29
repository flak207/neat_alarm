import 'dart:async';

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
        child: ListView.separated(
          itemCount: _alarms.length,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 0, color: appForeground),
          itemBuilder: (BuildContext context, int index) {
            final alarm = _alarms[index];
            return ListTile(
                title: alarm.buildTitle(context),
                subtitle: alarm.buildSubtitle(context),
                // leading: const Icon(Icons.timer),
                selectedTileColor: Colors.red,
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        alarm.isActive ? Icons.timer : Icons.timer_off,
                        color: appForeground,
                      ),
                      onPressed: () {
                        _onSwitchIsActivePressed(alarm);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever_rounded,
                        color: appForeground,
                      ),
                      onPressed: () {
                        _onDeleteItemPressed(alarm);
                      },
                    ),
                  ],
                ));
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: addBtn,
        ));
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
          return NewTimerAlarmWidget(_addNewTimer);
        },
        isScrollControlled: true,
        backgroundColor: appBackground);
  }

  void _addNewTimer(TimerAlarm alarm) {
    setState(() {
      _alarms.add(alarm);
      NotificationService().scheduleAlarmNotification(alarm);
      addLocalTimer(alarm);
    });
    //StorageService().setAlarms(_alarms);
  }

  void _onDeleteItemPressed(TimerAlarm alarm) {
    setState(() {
      _alarms.remove(alarm);
    });
    NotificationService().cancelAlarmNotification(alarm);
  }

  void _onSwitchIsActivePressed(TimerAlarm alarm) {
    setState(() {
      alarm.isActive = !alarm.isActive;
      if (alarm.isActive) {
        alarm.dateTime = DateTime.now().add(Duration(
            hours: alarm.hours,
            minutes: alarm.minutes,
            seconds: alarm.seconds));
        NotificationService().scheduleAlarmNotification(alarm);
        addLocalTimer(alarm);
      } else {
        NotificationService().cancelAlarmNotification(alarm);
      }
    });
  }

  void addLocalTimer(alarm) {
    Duration difference =
        alarm.dateTime.difference(DateTime.now()) + const Duration(seconds: 2);
    Timer(
        difference,
        () => setState(() {
              for (var element in _alarms) {
                element.isActive = element.dateTime.isAfter(DateTime.now());
              }
            }));
  }
}
