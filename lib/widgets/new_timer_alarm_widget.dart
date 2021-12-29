import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/helpers.dart';

const nameHint = 'New Timer';
const descriptionHint = 'Some description...';

class NewTimerAlarmWidget extends StatefulWidget {
  final Function addAlarm;

  const NewTimerAlarmWidget(this.addAlarm, {Key? key}) : super(key: key);

  @override
  _NewTimerAlarmWidgetState createState() => _NewTimerAlarmWidgetState();
}

class _NewTimerAlarmWidgetState extends State<NewTimerAlarmWidget> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  double _hours = 0;
  double _minutes = 0;
  double _seconds = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    //_descriptionController.text = 'Some description...';
  }

  @override
  Widget build(BuildContext context) {
    var addBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: appBackground, onPrimary: appForeground),
      onPressed: _submitData,
      child: const Text('Add Timer'),
    );

    return SingleChildScrollView(
      child: Card(
        borderOnForeground: false,
        // color: appBackground,
        elevation: 5,
        child: Container(
          // color: widgetBackground,
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
                  value: 0,
                  max: 99,
                  decoration: const InputDecoration(labelText: 'Hours'),
                  onChanged: (value) => _hours = value),
              SpinBox(
                  min: 0,
                  value: 0,
                  max: 99,
                  decoration: const InputDecoration(labelText: 'Minutes'),
                  onChanged: (value) => _minutes = value),
              SpinBox(
                  min: 0,
                  value: 0,
                  max: 99,
                  decoration: const InputDecoration(labelText: 'Seconds'),
                  onChanged: (value) => _seconds = value),
              // TextField(
              //   decoration:
              //       const InputDecoration(labelText: 'Seconds', hintText: '0'),
              //   controller: _secondsController,
              //   keyboardType: TextInputType.number,
              //   inputFormatters: [
              //     FilteringTextInputFormatter.digitsOnly,
              //     LengthLimitingTextInputFormatter(2)
              //   ],
              // ),
              Padding(padding: const EdgeInsets.only(top: 10), child: addBtn)
            ],
          ),
        ),
      ),
    );
  }

  void _submitData() {
    final name = _nameController.text.isEmpty ? nameHint : _nameController.text;
    final description = _descriptionController.text.isEmpty
        ? descriptionHint
        : _descriptionController.text;
    if (_hours == 0 && _minutes == 0 && _seconds == 0) {
      debugPrint('Invalid timer!');

      showInfoDialog(context,
          'At least one of parameters (hours, minutes, seconds) must be positive number!',
          title: 'Invalid timer parameters');
      return;
    }

    var duration = Duration(
        hours: _hours.toInt(),
        minutes: _minutes.toInt(),
        seconds: _seconds.toInt());
    _selectedDate = DateTime.now().add(duration);

    widget.addAlarm(
      name,
      description,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }
}
