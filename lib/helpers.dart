import 'package:flutter/material.dart';

Future<void> showInfoDialog(BuildContext context, String text,
    {String title = 'Info'}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Invalid input!'),
    behavior: SnackBarBehavior.floating,
  ));
}
