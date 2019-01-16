import 'package:flutter/material.dart';
import 'package:amo_schedule/classes/lesson.dart' as les;

class Lesson extends StatelessWidget {
  final les.Lesson _lesson;

  Lesson(this._lesson);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _lesson.name ?? _lesson.summary ?? 'blame the def',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Text(
                _lesson.getTime(),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  (_lesson.classRoom != null) ? _lesson.classRoom.name : '-',
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  (_lesson.teacher != null) ? _lesson.teacher.name : '-',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  (_lesson.schoolClass != null) ? _lesson.schoolClass.name : '-',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
