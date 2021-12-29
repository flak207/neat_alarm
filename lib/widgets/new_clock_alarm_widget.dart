import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewClockAlarmWidget extends StatefulWidget {
  final Function addAlarm;

  const NewClockAlarmWidget(this.addAlarm, {Key? key}) : super(key: key);

  @override
  _NewClockAlarmWidgetState createState() => _NewClockAlarmWidgetState();
}

class _NewClockAlarmWidgetState extends State<NewClockAlarmWidget> {
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
              decoration: const InputDecoration(labelText: 'Name'),
              controller: _nameController,
              //onSubmitted: (_) => _submitData(),
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              controller: _descriptionController,
              // keyboardType: TextInputType.multiline,
              // onSubmitted: (_) => _submitData(),
              // onChanged: (val) => amountInput = val,
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate.isBefore(DateTime.now())
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  ),
                ],
              ),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              child: const Text('Add Alarm'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button!.color,
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
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
