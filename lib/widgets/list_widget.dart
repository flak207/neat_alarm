import 'dart:async';

import 'package:flutter/material.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/models/calendar_alarm.dart';
import 'package:neat_alarm/models/clock_alarm.dart';
import 'package:neat_alarm/models/timer_alarm.dart';
import 'package:neat_alarm/services/notification_service.dart';
import 'package:neat_alarm/services/storage_service.dart';
import 'package:neat_alarm/widgets/item_widget.dart';
import 'package:neat_alarm/widgets/timer_alarm_widget.dart';
import 'package:neat_alarm/widgets/calendar_alarm_widget.dart';
import 'package:neat_alarm/widgets/clock_alarm_widget.dart';

class ListWidget<T extends Alarm> extends StatefulWidget {
  final String title;

  const ListWidget(this.title, {Key? key}) : super(key: key);

  @override
  _ListWidgetState<T> createState() => _ListWidgetState<T>();
}

class _ListWidgetState<T extends Alarm> extends State<ListWidget> {
  List<T> _alarms = [];
  late final Map<Type, Widget> _typeItemWidgets = {
    ClockAlarm: ClockAlarmWidget(_addNewAlarm),
    TimerAlarm: TimerAlarmWidget(_addNewAlarm),
    CalendarAlarm: CalendarAlarmWidget(_addNewAlarm),
  };

  @override
  void initState() {
    _alarms = StorageService().getAlarms<T>();
    _updateAlarmsState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBarWdg = AppBar(
      title: Text(widget.title),
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
            return ItemWidget(
              alarm,
              index,
              _onSwitchIsActivePressed,
              _onEditAlarmPressed,
              _onDeleteAlarmPressed,
              activeIcon: alarm.getActiveIcon(),
              inactiveIcon: alarm.getInactiveIcon(),
            );
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
      //isDismissible: false,
      builder: (BuildContext context) {
        return _typeItemWidgets[T] ?? const Text('EditAlarmWidget');
      },
      isScrollControlled: true,
      backgroundColor: appBackground,
    );
  }

  void _addNewAlarm(T alarm) {
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
    StorageService().saveAlarms(_alarms);
  }

  void _onEditAlarmPressed(T alarm) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          var widget = alarm.buildEditWidget(context, _addNewAlarm);
          return widget;
        },
        isScrollControlled: true,
        backgroundColor: appBackground);
  }

  void _onDeleteAlarmPressed(T alarm) {
    setState(() {
      _alarms.remove(alarm);
      NotificationService().cancelAlarmNotification(alarm);
      StorageService().saveAlarms(_alarms);
    });
  }

  void _onSwitchIsActivePressed(T alarm) {
    setState(() {
      alarm.isActive = !alarm.isActive;
      if (alarm.isActive) {
        alarm.dateTime = alarm.getActualDateTime();
        NotificationService().scheduleAlarmNotification(alarm);
        _addLocalTimer(alarm);
      } else {
        NotificationService().cancelAlarmNotification(alarm);
      }
      StorageService().saveAlarms(_alarms);
    });
  }

  void _addLocalTimer(T alarm) {
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
