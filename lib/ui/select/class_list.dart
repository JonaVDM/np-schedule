import 'package:flutter/material.dart';
import 'package:amo_schedule/models/classes.dart' as model;

class ClassList extends StatelessWidget {
  final List<model.SchoolClass> list;

  ClassList(this.list);

  final Container _divider = Container(
    padding: EdgeInsets.all(5),
    child: Divider(),
  );

  List<Widget> _list() {
    List<Widget> _l = [];

    for (model.SchoolClass c in list) {
      _l.add(ListTile(
        title: Text(c.name),
      ));
      _l.add(_divider);
    }

    return _l;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: _list(),
      ),
    );
  }
}
