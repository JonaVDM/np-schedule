import 'package:flutter/material.dart';
import 'package:amo_schedule/classes/day.dart' as day;
import 'package:amo_schedule/classes/lesson.dart' as lesson;
import 'package:amo_schedule/ui/home/lesson.dart';
import 'package:amo_schedule/ui/list_divider.dart';

class DaySlide extends StatelessWidget {
  final day.Day _day;
  DaySlide(this._day);

  List<Widget> _lessons() {
    List<Widget> l = [];
    l.add(ListDivider());
    if (_day.lessons.length <= 0) {
      l.add(
        Center(
          child: Column(
            children: <Widget>[
              Text(
                'Geen lessen',
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              Text(
                ':D',
                style: TextStyle(
                  fontSize: 30.0
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      for (lesson.Lesson les in _day.lessons) {
        l.add(Lesson(les));
        l.add(ListDivider());
      }
    }

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              _day.toString(),
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: _lessons(),
            ),
          ),
        ],
      ),
    );
  }
}
