import 'package:flutter/material.dart';
import 'package:neat_alarm/constants.dart';
import 'package:neat_alarm/models/alarm.dart';

class ItemWidget extends StatelessWidget {
  final Alarm alarm;
  final int index;
  final IconData activeIcon;
  final IconData inactiveIcon;

  final Function onSwitchIsActivePressed;
  final Function onEditItemPressed;
  final Function onDeleteItemPressed;

  const ItemWidget(this.alarm, this.index, this.onSwitchIsActivePressed,
      this.onEditItemPressed, this.onDeleteItemPressed,
      {Key? key,
      this.activeIcon = Icons.notifications,
      this.inactiveIcon = Icons.notifications_off})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: alarm.buildTitle(context),
      tileColor: index % 2 == 0 ? Colors.transparent : widgetBackgroundDark,
      subtitle: alarm.buildSubtitle(context),
      // minLeadingWidth: 10,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 5,
      leading: IconButton(
        icon: Icon(
          alarm.isActive ? activeIcon : inactiveIcon,
          color: editButtonColor,
        ),
        onPressed: () {
          onSwitchIsActivePressed(alarm);
        },
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit_notifications,
              color: appForeground,
            ),
            onPressed: () {
              onEditItemPressed(alarm);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever_rounded,
              color: Colors.deepOrange[600],
            ),
            onPressed: () {
              onDeleteItemPressed(alarm);
            },
          ),
        ],
      ),
    );
  }
}
