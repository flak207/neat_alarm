import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/services/notification_service.dart';
import 'package:neat_alarm/services/storage_service.dart';
import 'package:neat_alarm/widgets/alarms_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await StorageService().init();
  tz.initializeTimeZones();
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: applicationName,
      home: NavigationWidget(),
    );
  }
}

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AlarmsList(),
    AlarmsList(),
    AlarmsList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
          activeColor: appForeground,
          backgroundColor: appBackground,
          color: appForeground,
          style: TabStyle.textIn,
          items: const <TabItem>[
            TabItem(icon: Icons.alarm_outlined, title: 'Alarms'),
            TabItem(icon: Icons.timer_outlined, title: 'Timers'),
            TabItem(icon: Icons.calendar_today_outlined, title: 'Calendar'),
          ],
          initialActiveIndex: 1,
          onTap: _onItemTapped),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
