import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as model;
import 'package:amo_schedule/ui/schedule/schedule.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  model.Schedule _schedule;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _schedule = await model.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_schedule.className ?? 'Schedule loading'),
      ),
      body: Schedule(_schedule),
    );
  }
}
