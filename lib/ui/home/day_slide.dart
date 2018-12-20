import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as model;
import 'package:amo_schedule/ui/home/lesson.dart';
import 'package:amo_schedule/ui/list_divider.dart';

class DaySlide extends StatelessWidget {
  final model.Day _day;
  DaySlide(this._day);

  List<Widget> _lessons() {
    List<Widget> l = [];
    l.add(ListDivider());
    for (model.Lesson les in _day.lessons) {
      l.add(Lesson(les));
      l.add(ListDivider());
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
