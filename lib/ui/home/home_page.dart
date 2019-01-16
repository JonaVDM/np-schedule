import 'package:flutter/material.dart';
import 'package:amo_schedule/models/model.dart';
import 'package:amo_schedule/classes/schedule.dart' as scheduleClass;
import 'package:amo_schedule/classes/day.dart' as days;
import 'package:amo_schedule/ui/loading.dart';
import 'package:amo_schedule/ui/home/day_slide.dart';
import 'package:amo_schedule/ui/drawer/app_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  scheduleClass.Schedule _schedule;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _schedule = await Model.schedule.fetch();
    _controller = TabController(
      length: _schedule.days.length,
      vsync: this,
      initialIndex: _schedule.todayIndex(),
    );
    setState(() {});
  }

  void switchClass() {
    setState(() {
      _schedule = null;
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (_schedule != null) ? _schedule.group.name : 'Loading',
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _controller.index = _schedule.todayIndex();
            },
          ),
        ],
      ),
      drawer: AppDrawer(switchClass),
      body: (_schedule == null) ? Loading() : TabBarView(
        children: _schedule.days.map((d) => DaySlide(d)).toList(),
        controller: _controller,
      ),
    );
  }
}
