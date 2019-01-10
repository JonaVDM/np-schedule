import 'package:flutter/material.dart';
import 'package:amo_schedule/models/classes.dart' as model;
import 'package:amo_schedule/ui/loading.dart';
import 'package:amo_schedule/ui/select/class_list.dart';
import 'package:amo_schedule/classes/school_class.dart';

class SelectPage extends StatefulWidget {
  final VoidCallback callback;

  SelectPage(this.callback);

  @override
  SelectPageState createState() {
    return new SelectPageState();
  }
}

class SelectPageState extends State<SelectPage> {
  ListTile selection(BuildContext context, String name) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  List<SchoolClass> _classes;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _classes = await model.fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((_classes == null) ? 'Loading...' : 'Select a class'),
        centerTitle: true,
      ),
      body: (_classes == null) ? Loading() : ClassList(_classes, widget.callback),
    );
  }
}
