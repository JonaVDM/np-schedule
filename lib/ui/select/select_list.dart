import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:np_schedule/stores/schedule/store.dart';
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/ui/list_divider.dart';
import 'package:np_schedule/ui/static_text.dart';

class SelectList extends StatefulWidget {
  final List<Group> list;

  SelectList(this.list);

  @override
  SelectListState createState() {
    return new SelectListState();
  }
}

class SelectListState extends State<SelectList>
  with StoreWatcherMixin<SelectList> {
  TextEditingController _controller = TextEditingController();
  List<Group> _filtered;
  ScheduleStore store;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_update);
    _filtered = widget.list;
    store = listenToStore(scheduleStoreToken);
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

    for (Group c in _filtered) {
      _l.add(ListTile(
        title: Text(c.name),
        onTap: () {
          setState(() {
            saveGroup(c);
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
            decoration: InputDecoration(hintText: StaticText.search),
            controller: _controller,
            autofocus: true,
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

