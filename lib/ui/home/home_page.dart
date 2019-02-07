import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:np_schedule/stores/schedule/store.dart';
import 'package:np_schedule/ui/loading.dart';
import 'package:np_schedule/ui/home/day_slide.dart';
import 'package:np_schedule/ui/drawer/app_drawer.dart';
import 'package:np_schedule/ui/landing/landings_page.dart';
import 'package:np_schedule/ui/static_text.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin, StoreWatcherMixin<HomePage> {
  TabController _controller;
  bool _first = false;
  int index = 0;
  ScheduleStore store;

  @override
  void initState() {
    super.initState();
    store = listenToStore(scheduleStoreToken, loadData);
  }

  void loadData(Store st) {
    _first = store.selected == null;
    if (!_first && store.schedule != null) {
      index = store.schedule.today;
      _controller = TabController(
        length: store.schedule.days.length,
        vsync: this,
        initialIndex: index,
      );
    }
    setState(() {});
  }

  Widget body() {
    if (_first) {
      return LandingsPage();
    } else if (store.schedule != null && store.schedule.days.length >= 1) {
      return Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              children: store.schedule.days.map((d) => DaySlide(d)).toList(),
              controller: _controller,
            ),
          ),
        ],
      );
    } else if (store.schedule != null) {
      return Center(
        child: Column(
          children: <Widget>[
            Text(
              StaticText.noSchedule,
              style: TextStyle(fontSize: 25.0),
            ),
            Text(
              StaticText.sad,
              style: TextStyle(fontSize: 30.0),
            ),
          ],
        ),
      );
    } else {
      return Loading();
    }
  }

  Widget drawer() {
    if (!_first) return AppDrawer();
    return null;
  }

  Widget bar() {
    if (!_first)
      return AppBar(
        title: Text(
          (store.schedule != null) ? store.schedule.group.name : StaticText.loading,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _controller.index = store.schedule.today;
            },
          ),
        ],
      );
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bar(),
      drawer: drawer(),
      body: body(),
    );
  }
}
