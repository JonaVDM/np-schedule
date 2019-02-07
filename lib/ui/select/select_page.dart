import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:np_schedule/classes/group.dart';
// import 'package:np_schedule/models/model.dart';
import 'package:np_schedule/stores/groups/store.dart';
import 'package:np_schedule/ui/loading.dart';
import 'package:np_schedule/ui/select/select_list.dart';
import 'package:np_schedule/ui/static_text.dart';

class SelectPage extends StatefulWidget {
  final VoidCallback callback;
  final int which;

  SelectPage(this.callback, this.which);

  @override
  SelectPageState createState() {
    return new SelectPageState();
  }
}

class SelectPageState extends State<SelectPage>
  with StoreWatcherMixin<SelectPage> {

  GroupStore store;

  void switchGroup(Group group) {
    // Model.selected.save(group);
    widget.callback();
  }

  List<Group> list() {
    switch (widget.which) {
      case Group.classes:
        return store.classes;
      case Group.teachers:
        return store.teachers;
      case Group.rooms:
        return store.rooms;
      default:
        return null;
    }
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
    store = listenToStore(groupStoreToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((list().length == 0) ? StaticText.loading : title()),
        centerTitle: true,
      ),
      body: (list().length == 0) ? Loading() : SelectList(list(), (Group g) {}),
    );
  }
}

