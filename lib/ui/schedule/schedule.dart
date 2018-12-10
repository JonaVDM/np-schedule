import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as Model;
import 'package:amo_schedule/ui/schedule/lesson.dart';

class Schedule extends StatelessWidget {
  final Model.Schedule _schedule;

  Schedule(this._schedule);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: this._schedule.lessons.map((l) => Lesson(l)).toList(),
      ),
    );
  }
}
