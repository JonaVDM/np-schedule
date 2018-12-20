import 'package:flutter/material.dart';
import 'package:amo_schedule/models/classes.dart' as model;
import 'package:amo_schedule/ui/list_divider.dart';

class ClassList extends StatefulWidget {
  final List<model.SchoolClass> list;

  ClassList(this.list);

  @override
  ClassListState createState() {
    return new ClassListState();
  }
}

class ClassListState extends State<ClassList> {
  TextEditingController _controller = TextEditingController();
  List<model.SchoolClass> _filtered;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_update);
    _filtered = widget.list;
  }

  void _update() {
    setState(() {
      if (_controller.text.isEmpty) {
        _filtered = widget.list;
      } else {
        _filtered = [];
        for (var c in widget.list) {
          if (c.name.contains(_controller.text.toLowerCase()) ||
              c.name.contains(_controller.text.toUpperCase())) {
            _filtered.add(c);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  List<Widget> _list() {
    List<Widget> _l = [];

    for (model.SchoolClass c in _filtered) {
      _l.add(ListTile(
        title: Text(c.name),
        onTap: () {
          setState(() {
            Navigator.pop(context);
          });
        },
      ));
      _l.add(ListDivider());
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
            style: TextStyle(fontSize: 22.0),
            decoration: InputDecoration(hintText: 'Search'),
            controller: _controller,
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
