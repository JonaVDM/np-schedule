import 'package:flutter/material.dart';
import 'package:amo_schedule/ui/select/select_page.dart';
import 'package:amo_schedule/classes/group.dart';


class AppDrawer extends StatelessWidget {
  final VoidCallback callback;

  AppDrawer(this.callback);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Select class'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return SelectPage(callback, Group.classes);
              }));
            },
          ),
        ],
      ),
    );
  }
}
