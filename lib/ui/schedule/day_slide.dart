import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as model;
import 'package:amo_schedule/ui/schedule/lesson.dart';

class DaySlide extends StatelessWidget {
  final List<model.Lesson> _lessons;

  DaySlide(this._lessons);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: _lessons.map((les) => Lesson(les)).toList(),
      ),
    );
  }
}
