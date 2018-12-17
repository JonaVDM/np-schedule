import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as Model;
import 'package:amo_schedule/ui/schedule/day_slide.dart';

class Schedule extends StatefulWidget {
  final Model.Schedule _schedule;

  Schedule(this._schedule);

  @override
  ScheduleState createState() {
    return new ScheduleState();
  }
}

class ScheduleState extends State<Schedule> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(
      length: widget._schedule.perDay().length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: widget._schedule.perDay().map((d) => DaySlide(d.lessons)).toList(),
      controller: _controller,
    );
  }
}
