import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as model;
import 'package:amo_schedule/ui/schedule/lesson.dart';

class DaySlide extends StatelessWidget {
  final model.Day _day;
  DaySlide(this._day);

  final Container _divider = Container(
    child: Divider(),
    padding: EdgeInsets.symmetric(horizontal: 10.0),
  );

  List<Widget> _lessons() {
    List<Widget> l = [];
    l.add(_divider);
    for (model.Lesson les in _day.lessons) {
      l.add(Lesson(les));
      l.add(_divider);
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
