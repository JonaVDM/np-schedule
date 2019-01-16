import 'package:flutter/material.dart';
import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/models/classes.dart' as classModel;
import 'package:amo_schedule/models/teachers.dart' as teacherModel;
import 'package:amo_schedule/models/classroom.dart' as roomModel;
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
    classModel.saveSelected(group);
    widget.callback();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    if (widget.which == Group.classes) {
      _list = await classModel.fetch();
    } else if (widget.which == Group.teachers) {
      _list = await teacherModel.fetch();
    } else if (widget.which == Group.rooms) {
      _list = await roomModel.load();
    } else {
      _list = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((_list == null) ? 'Loading...' : 'Select a class'),
        centerTitle: true,
      ),
      body: (_list == null) ? Loading() : SelectList(_list, switchGroup),
    );
  }
}
