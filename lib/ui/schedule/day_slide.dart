import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as model;
import 'package:amo_schedule/ui/schedule/lesson.dart';

class DaySlide extends StatelessWidget {
  final model.Day _day;
  DaySlide(this._day);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(_day.toString()),
          Expanded(
            child: ListView(
              children: _day.lessons.map((les) => Lesson(les)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
