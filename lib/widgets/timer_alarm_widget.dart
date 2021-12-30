import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/helpers.dart';
import 'package:neat_alarm/models/alarm.dart';
import 'package:neat_alarm/models/timer_alarm.dart';

const nameHint = 'New Timer';
const descriptionHint = 'Some description...';

class TimerAlarmWidget extends StatefulWidget {
  final Function addTimer;
  final TimerAlarm? alarm;

  const TimerAlarmWidget(this.addTimer, {this.alarm, Key? key})
      : super(key: key);

  @override
  _TimerAlarmWidgetState createState() => _TimerAlarmWidgetState();
}

class _TimerAlarmWidgetState extends State<TimerAlarmWidget> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  num _hours = 0;
  num _minutes = 0;
  num _seconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _hours = widget.alarm!.hours;
      _minutes = widget.alarm!.minutes;
      _seconds = widget.alarm!.seconds;

      _nameController.text = widget.alarm!.name;
      _descriptionController.text = widget.alarm!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    var addBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: appBackground, onPrimary: appForeground),
      onPressed: _submitData,
      child: Text(widget.alarm != null ? 'Update Timer' : 'Add Timer'),
    );

    return SingleChildScrollView(
      child: Card(
        borderOnForeground: false,
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(hintText: nameHint),
                controller: _nameController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: descriptionHint),
                controller: _descriptionController,
              ),
              SpinBox(
                  min: 0,
                  value: _hours.toDouble(),
                  max: 99,
                  decoration: const InputDecoration(labelText: 'Hours'),
                  onChanged: (value) => _hours = value),
              SpinBox(
                  min: 0,
                  value: _minutes.toDouble(),
                  max: 99,
                  decoration: const InputDecoration(labelText: 'Minutes'),
                  onChanged: (value) => _minutes = value),
              SpinBox(
                  min: 0,
                  value: _seconds.toDouble(),
                  max: 99,
                  decoration: const InputDecoration(labelText: 'Seconds'),
                  onChanged: (value) => _seconds = value),
              Padding(padding: const EdgeInsets.only(top: 10), child: addBtn)
            ],
          ),
        ),
      ),
    );
  }

  void _submitData() {
    final name = _nameController.text.isEmpty ? nameHint : _nameController.text;
    final description =
        _descriptionController.text.isEmpty ? '' : _descriptionController.text;
    if (_hours == 0 && _minutes == 0 && _seconds == 0) {
      debugPrint('Invalid timer!');

      showInfoDialog(context,
          'At least one of parameters (hours, minutes, seconds) must be positive number!',
          title: 'Invalid timer parameters');
      return;
    }

    int hours = _hours.toInt();
    int minutes = _minutes.toInt();
    int seconds = _seconds.toInt();
    var dateTime = DateTime.now()
        .add(Duration(hours: hours, minutes: minutes, seconds: seconds));

    var alarm = widget.alarm;
    if (alarm == null) {
      alarm = TimerAlarm(name, dateTime, hours, minutes, seconds,
          description: description);
    } else {
      alarm.hours = hours;
      alarm.minutes = minutes;
      alarm.seconds = seconds;
      alarm.dateTime = dateTime;
      alarm.name = name;
      alarm.description = description;
    }

    widget.addTimer(alarm);
    Navigator.of(context).pop();
  }
}
