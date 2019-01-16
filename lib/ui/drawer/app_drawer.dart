import 'package:flutter/material.dart';
import 'package:amo_schedule/ui/select/select_page.dart';
import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/ui/list_divider.dart';


class AppDrawer extends StatelessWidget {
  final VoidCallback callback;

  AppDrawer(this.callback);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'Kies',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Klas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return SelectPage(callback, Group.classes);
              }));
            },
          ),
          ListTile(
            title: Text(
              'Docent',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return SelectPage(callback, Group.teachers);
              }));
            },
          ),
          ListDivider(),
        ],
      ),
    );
  }
}
