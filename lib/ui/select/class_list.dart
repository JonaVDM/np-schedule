import 'package:flutter/material.dart';
import 'package:amo_schedule/models/classes.dart' as model;

class ClassList extends StatefulWidget {
  final List<model.SchoolClass> list;

  ClassList(this.list);

  @override
  ClassListState createState() {
    return new ClassListState();
  }
}

class ClassListState extends State<ClassList> {
  final Container _divider = Container(
    padding: EdgeInsets.all(5),
    child: Divider(),
  );

  List<Widget> _list() {
    List<Widget> _l = [];

    for (model.SchoolClass c in widget.list) {
      _l.add(ListTile(
        title: Text(c.name),
      ));
      _l.add(_divider);
    }

    return _l;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          child: TextField(
            style: TextStyle(
              fontSize: 22.0
            ),
            decoration: InputDecoration(
              hintText: 'Search'
            ),
          ),
        ),

        Expanded(
          child: ListView(
            children: _list(),
          ),
        ),
      ],
    );
  }
}
