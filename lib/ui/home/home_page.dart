import 'package:flutter/material.dart';
import 'package:amo_schedule/models/model.dart';
import 'package:amo_schedule/classes/schedule.dart' as scheduleClass;
import 'package:amo_schedule/ui/loading.dart';
import 'package:amo_schedule/ui/home/day_slide.dart';
import 'package:amo_schedule/ui/drawer/app_drawer.dart';
import 'package:amo_schedule/ui/landing/landings_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  scheduleClass.Schedule _schedule;
  TabController _controller;
  bool _first = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _first = await Model.selected.empty();
    if (!_first) {
      _schedule = await Model.schedule.fetch();
      _controller = TabController(
        length: _schedule.days.length,
        vsync: this,
        initialIndex: _schedule.todayIndex(),
      );
    }
    setState(() {});
  }

  Widget body() {
    if (_first) {
      return LandingsPage(switchClass);
    } else if (_schedule != null && _schedule.days.length >= 1) {
      return TabBarView(
        children: _schedule.days.map((d) => DaySlide(d)).toList(),
        controller: _controller,
      );
    } else if (_schedule != null) {
      return Center(
        child: Text('Geen rooster gevonden'),
      );
    } else {
      return Loading();
    }
  }

  Widget drawer() {
    if (!_first) return AppDrawer(switchClass);
    return null;
  }

  Widget bar() {
    if (!_first)
      return AppBar(
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
      );
    return null;
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
        appBar: bar(),
        drawer: drawer(),
        body: body(),
      );
    return Scaffold(
      body: body(),
    );
  }
}
