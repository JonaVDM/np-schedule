import 'package:flutter/material.dart';
import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/models/model.dart';
import 'package:amo_schedule/ui/loading.dart';
import 'package:amo_schedule/ui/select/select_list.dart';
import 'package:amo_schedule/ui/static_text.dart';

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
      return StaticText.selectClass;
    } else if (widget.which == Group.teachers) {
      return StaticText.selectTeacher;
    } else if (widget.which == Group.rooms) {
      return StaticText.selectRoom;
    } else {
      return StaticText.selectNull;
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
        title: Text((_list == null) ? StaticText.loading : title()),
        centerTitle: true,
      ),
      body: (_list == null) ? Loading() : SelectList(_list, switchGroup),
    );
  }
}
