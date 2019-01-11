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
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _lesson.name ?? _lesson.summary ?? 'blame the def',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text((_lesson.classRoom != null) ? _lesson.classRoom.code : '-'),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(_lesson.getTime()),
              Text(_lesson.teacher),
            ],
          ),
        ],
      ),
    );
  }
}
