import 'package:flutter/material.dart';

class NewTimerAlarmWidget extends StatefulWidget {
  final Function addAlarm;

  const NewTimerAlarmWidget(this.addAlarm, {Key? key}) : super(key: key);

  @override
  _NewTimerAlarmWidgetState createState() => _NewTimerAlarmWidgetState();
}

class _NewTimerAlarmWidgetState extends State<NewTimerAlarmWidget> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Name', hintText: 'Enter Timer Name'),
              controller: _nameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              controller: _descriptionController,
            ),

            // ignore: deprecated_member_use
            RaisedButton(
              child: const Text('Add Timer'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button!.color,
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }

  void _submitData() {
    final enteredName = _nameController.text;
    final enteredDescription = _descriptionController.text;
    if (enteredName.isEmpty || _selectedDate.isBefore(DateTime.now())) {
      return;
    }

    widget.addAlarm(
      enteredName,
      enteredDescription,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }
}
