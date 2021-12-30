import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/models/clock_alarm.dart';
import 'package:neat_alarm/services/notification_service.dart';
import 'package:neat_alarm/services/storage_service.dart';
import 'package:neat_alarm/widgets/clock_alarm_widget.dart';

class ClockAlarmsListWidget extends StatefulWidget {
  const ClockAlarmsListWidget({Key? key}) : super(key: key);

  @override
  _ClockAlarmsListWidgetState createState() => _ClockAlarmsListWidgetState();
}

class _ClockAlarmsListWidgetState extends State<ClockAlarmsListWidget> {
  List<ClockAlarm> _alarms = [];

  @override
  void initState() {
    _alarms = StorageService().getClockAlarms();
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
        child: ListView.separated(
          itemCount: _alarms.length,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 0, color: appForeground),
          itemBuilder: (BuildContext context, int index) {
            final alarm = _alarms[index];
            return ListTile(
                title: alarm.buildTitle(context),
                tileColor:
                    index % 2 == 0 ? Colors.transparent : widgetBackgroundDark,
                subtitle: alarm.buildSubtitle(context),
                // minLeadingWidth: 10,
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 5,
                leading: IconButton(
                  icon: Icon(
                    alarm.isActive ? Icons.alarm : Icons.alarm_off,
                    color: Colors.blue[500],
                  ),
                  onPressed: () {
                    _onSwitchIsActivePressed(alarm);
                  },
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.edit_notifications,
                        color: appForeground,
                      ),
                      onPressed: () {
                        _onEditItemPressed(alarm);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red[600],
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
        backgroundColor: widgetBackgroundLight,
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
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: ClockAlarmWidget(_addNewAlarm),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewAlarm(ClockAlarm alarm) {
    setState(() {
      if (!_alarms.contains(alarm)) {
        _alarms.insert(0, alarm);
      } else {
        NotificationService().cancelAlarmNotification(alarm);
      }
      if (alarm.isActive) {
        NotificationService().scheduleAlarmNotification(alarm);
        _addLocalTimer(alarm);
      }
    });
    StorageService().setClockAlarms(_alarms);
  }

  void _onEditItemPressed(ClockAlarm alarm) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ClockAlarmWidget(_addNewAlarm, alarm: alarm);
        },
        isScrollControlled: true,
        backgroundColor: appBackground);
  }

  void _onDeleteItemPressed(ClockAlarm alarm) {
    setState(() {
      _alarms.remove(alarm);
    });
    NotificationService().cancelAlarmNotification(alarm);
  }

  void _onSwitchIsActivePressed(ClockAlarm alarm) {
    setState(() {
      alarm.isActive = !alarm.isActive;
      if (alarm.isActive) {
        if (alarm.dateTime.isBefore(DateTime.now())) {
          alarm.dateTime = Jiffy(alarm.dateTime).add(days: 1).dateTime;
        }
        NotificationService().scheduleAlarmNotification(alarm);
        _addLocalTimer(alarm);
      } else {
        NotificationService().cancelAlarmNotification(alarm);
      }
    });
  }

  void _addLocalTimer(Alarm alarm) {
    Duration difference =
        alarm.dateTime.difference(DateTime.now()) + const Duration(seconds: 2);
    Timer(difference, () => setState(() => _updateAlarmsState()));
  }

  void _updateAlarmsState() {
    for (var element in _alarms) {
      element.isActive =
          element.isActive && element.dateTime.isAfter(DateTime.now());
    }
  }
}
