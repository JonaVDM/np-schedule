import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as model;
import 'package:amo_schedule/ui/loading.dart';
import 'package:amo_schedule/ui/select/select_page.dart';
import 'package:amo_schedule/ui/home/day_slide.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  model.Schedule _schedule;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _schedule = await model.fetch();
    _controller = TabController(
      length: _schedule.perDay().length,
      vsync: this,
    );
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Select class'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return SelectPage();
                  }
                ));
              },
            ),
          ],
        ),
      ),
      body: (_schedule == null) ? Loading() : TabBarView(
        children: _schedule.perDay().map((d) {
          d.lessons.sort((a, b) => a.startTime.compareTo(b.startTime));
          return DaySlide(d);
        }).toList(),
        controller: _controller,
      ),
    );
  }
}
