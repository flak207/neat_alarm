import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import './service/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  tz.initializeTimeZones();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    AppBar appBarWdg = AppBar(title: const Text('Neat Alarm'));

    var btnAddAlarm = ElevatedButton(
        child: const Text(
          'Add New Alarm 7',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () async {
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          debugPrint('Clicked $formattedDate');

          NotificationService().showNotification("TEST");
        });
    var btnContainer = Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: btnAddAlarm);
    Widget bodyWdg = Column(children: [btnContainer]);

    Scaffold scaffold = Scaffold(appBar: appBarWdg, body: bodyWdg);
    // MaterialApp, CupertinoApp, WidgetsApp
    MaterialApp baseApp = MaterialApp(home: scaffold);
    return baseApp;
  }
}
