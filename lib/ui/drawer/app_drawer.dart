import 'package:flutter/material.dart';
import 'package:np_schedule/ui/select/select_page.dart';
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/ui/list_divider.dart';
import 'package:np_schedule/ui/static_text.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback callback;

  AppDrawer(this.callback);

  @override
  Widget build(BuildContext context) {
    ListTile drawerTile(int target, String title) {
      return ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return SelectPage(callback, target);
            }),
          );
        },
      );
    }

    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              StaticText.select,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          drawerTile(Group.classes, StaticText.classes),
          drawerTile(Group.teachers, StaticText.teachers),
          drawerTile(Group.rooms, StaticText.rooms),
          ListDivider(),
        ],
      ),
    );
  }
}
