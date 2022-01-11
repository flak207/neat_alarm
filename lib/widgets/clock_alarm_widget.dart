import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:day_picker/day_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/helpers.dart';
import 'package:neat_alarm/models/clock_alarm.dart';
import 'package:neat_alarm/widgets/sound_dialog.dart';

const nameHint = 'New Alarm';
const descriptionHint = 'Some description...';

class ClockAlarmWidget extends StatefulWidget {
  final Function addAlarm;
  final ClockAlarm? alarm;

  const ClockAlarmWidget(this.addAlarm, {this.alarm, Key? key})
      : super(key: key);

  @override
  _ClockAlarmWidgetState createState() => _ClockAlarmWidgetState();
}

class _ClockAlarmWidgetState extends State<ClockAlarmWidget> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(minutes: 1));
  bool _isRecurring = false;

  String _soundName = 'Default Sound';
  String _soundPath = '';

  final List<DayInWeek> _days = [
    DayInWeek("Mon"),
    DayInWeek("Tue"),
    DayInWeek("Wed"),
    DayInWeek("Thu"),
    DayInWeek("Fri"),
    DayInWeek("Sat"),
    DayInWeek("Sun"),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _isRecurring = widget.alarm!.isRecurring;
      _selectedDate = widget.alarm!.dateTime;

      _nameController.text = widget.alarm!.name;
      _descriptionController.text = widget.alarm!.description;
      _soundName = widget.alarm!.soundName;
      _soundPath = widget.alarm!.soundPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dtCtrl = SizedBox(
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _selectedDate.isBefore(DateTime.now())
                  ? 'No Time Chosen!'
                  : 'Picked Time: ${DateFormat.Hms().format(_selectedDate)}',
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(primary: Colors.blue),
            child: const Text(
              'Choose Time',
            ),
            onPressed: _presentDatePicker,
          ),
        ],
      ),
    );

    var addBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: appBackground, onPrimary: appForeground),
      onPressed: _submitData,
      child: Text(widget.alarm != null ? 'Update Alarm' : 'Add Alarm'),
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
              dtCtrl,
              SelectWeekDays(
                days: _days,
                border: false,
                backgroundColor: Colors.blue,
                unSelectedDayTextColor: appForeground,
                selectedDayTextColor: appForeground,
                boxDecoration: BoxDecoration(
                  color: appBackground,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onSelect: (values) {
                  // <== Callback to handle the selected days
                  debugPrint(values.toString());
                },
              ),
              Padding(padding: const EdgeInsets.only(top: 10), child: addBtn)
            ],
          ),
        ),
      ),
    );
  }

  void _presentDatePicker() {
    DatePicker.showTimePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        _selectedDate = date;
        if (_selectedDate.isBefore(DateTime.now())) {
          _selectedDate = Jiffy(_selectedDate).add(days: 1).dateTime;
        }
      });
    }, currentTime: _selectedDate);
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
    if (_selectedDate.isBefore(DateTime.now())) {
      showInfoDialog(context, 'Invalid selected date or time!',
          title: 'Invalid alarm parameters');
      return;
    }

    var dateTime = _selectedDate;
    var alarm = widget.alarm;
    if (alarm == null) {
      alarm = ClockAlarm(name, dateTime, _isRecurring,
          description: description,
          soundName: _soundName,
          soundPath: _soundPath);
    } else {
      alarm.isRecurring = _isRecurring;
      alarm.dateTime = dateTime;
      alarm.name = name;
      alarm.description = description;
      alarm.soundName = _soundName;
      alarm.soundPath = _soundPath;
    }

    widget.addAlarm(alarm);
    Navigator.of(context).pop();
  }
}
