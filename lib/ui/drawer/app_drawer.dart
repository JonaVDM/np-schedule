import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/stores/schedule/store.dart';
import 'package:np_schedule/ui/select/select_page.dart';
import 'package:np_schedule/ui/list_divider.dart';
import 'package:np_schedule/ui/static_text.dart';

class AppDrawer extends StatefulWidget {
  @override
  AppDrawerState createState() {
    return new AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer>
    with StoreWatcherMixin<AppDrawer> {
  ScheduleStore store;

  @override
  void initState() {
    super.initState();
    store = listenToStore(scheduleStoreToken);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> recentItems() {
      List<Widget> list = [];
      for (Group item in store.recent) {
        list.add(ListTile(
          leading: Icon(
            Icons.history,
          ),
          title: Text(
            item.name,
          ),
          onTap: () {
            saveGroup(item);
            Navigator.pop(context);
          },
        ));
      }
      list.add(Divider());
      return list;
    }

    ListTile drawerTile(int target, String title) {
      return ListTile(
        title: Text(
          title,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return SelectPage(target);
            }),
          );
        },
      );
    }

    List<Widget> tileList() {
      List<Widget> list = [];
      list.addAll([
        drawerTile(Group.classes, '${StaticText.select} ${StaticText.classes}'),
        drawerTile(
            Group.teachers, '${StaticText.select} ${StaticText.teachers}'),
        drawerTile(Group.rooms, '${StaticText.select} ${StaticText.rooms}'),
        ListDivider(),
      ]);
      list.addAll(recentItems());
      return list;
    }

    return Drawer(
      child: ListView(
        children: tileList(),
      ),
    );
  }
}
