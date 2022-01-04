import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/calendar_alarm.dart';
import 'package:neat_alarm/models/clock_alarm.dart';
import 'package:neat_alarm/models/timer_alarm.dart';
import 'package:neat_alarm/widgets/list_widget.dart';
import 'package:neat_alarm/services/notification_service.dart';
import 'package:neat_alarm/services/storage_service.dart';

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
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    ListWidget<ClockAlarm>(alarmsTitle),
    ListWidget<TimerAlarm>(timersTitle),
    ListWidget<CalendarAlarm>(calendarTitle),
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
            TabItem(icon: Icons.alarm_outlined, title: alarmsTitle),
            TabItem(icon: Icons.timer_outlined, title: timersTitle),
            TabItem(icon: Icons.calendar_today_outlined, title: calendarTitle),
          ],
          initialActiveIndex: _selectedIndex,
          onTap: _onItemTapped),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
