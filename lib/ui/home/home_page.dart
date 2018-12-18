import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as model;
import 'package:amo_schedule/ui/schedule/schedule.dart';
import 'package:amo_schedule/ui/home/loading.dart';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (_schedule != null) ? _schedule.className : 'Loading',
        ),
        centerTitle: true,
      ),
      body: (_schedule != null) ? Schedule(_schedule) : Loading(),
    );
  }
}
