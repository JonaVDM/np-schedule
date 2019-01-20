import 'package:flutter/material.dart';
import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/models/model.dart';
import 'package:amo_schedule/ui/loading.dart';
import 'package:amo_schedule/ui/select/select_list.dart';

class SelectPage extends StatefulWidget {
  final VoidCallback callback;
  final int which;

  SelectPage(this.callback, this.which);

  @override
  SelectPageState createState() {
    return new SelectPageState();
  }
}

class SelectPageState extends State<SelectPage> {
  List<Group> _list;

  void switchGroup(Group group) {
    Model.selected.save(group);
    widget.callback();
  }

  String title() {
    if (widget.which == Group.classes) {
      return 'Kies een klas';
    } else if (widget.which == Group.teachers) {
      return 'Kies een docent';
    } else if (widget.which == Group.rooms) {
      return 'Kies een lokaal';
    } else {
      return 'Kies een bug! wait what?';
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    if (widget.which == Group.classes) {
      _list = await Model.fetch.classes();
    } else if (widget.which == Group.teachers) {
      _list = await Model.fetch.teachers();
    } else if (widget.which == Group.rooms) {
      _list = await Model.fetch.rooms();
    } else {
      _list = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((_list == null) ? 'Laaden...' : title()),
        centerTitle: true,
      ),
      body: (_list == null) ? Loading() : SelectList(_list, switchGroup),
    );
  }
}
