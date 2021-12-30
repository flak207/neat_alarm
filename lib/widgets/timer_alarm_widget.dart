import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/helpers.dart';
import 'package:neat_alarm/models/timer_alarm.dart';
import 'package:neat_alarm/widgets/sound_dialog.dart';

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

  String _soundName = 'Default Sound';
  String _soundPath = '';

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _hours = widget.alarm!.hours;
      _minutes = widget.alarm!.minutes;
      _seconds = widget.alarm!.seconds;

      _nameController.text = widget.alarm!.name;
      _descriptionController.text = widget.alarm!.description;
      _soundName = widget.alarm!.soundName;
      _soundPath = widget.alarm!.soundPath;
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

    var soundContainer = Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.grey,
      ))),
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _soundName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(primary: Colors.blue),
            onPressed: _selectSound,
            child: const Text('Choose Sound'),
          )
        ],
      ),
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
              soundContainer,
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

  void _selectSound() {
    showSoundDialog(context, _soundName, _updateSound);
  }

  void _updateSound(String soundName, String soundPath) {
    setState(() {
      _soundName = soundName;
      _soundPath = soundPath;
    });
  }

  void _submitData() {
    final name = _nameController.text.isEmpty ? nameHint : _nameController.text;
    final description =
        _descriptionController.text.isEmpty ? '' : _descriptionController.text;
    if (_hours == 0 && _minutes == 0 && _seconds == 0) {
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
          description: description,
          soundName: _soundName,
          soundPath: _soundPath);
    } else {
      alarm.hours = hours;
      alarm.minutes = minutes;
      alarm.seconds = seconds;
      alarm.dateTime = dateTime;
      alarm.name = name;
      alarm.description = description;
      alarm.soundName = _soundName;
      alarm.soundPath = _soundPath;
    }

    widget.addTimer(alarm);
    Navigator.of(context).pop();
  }
}
