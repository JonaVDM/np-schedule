import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as Model;

class Lesson extends StatelessWidget {
  final Model.Lesson _lesson;

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
                Text(_lesson.classRoom ?? '-'),
              ],
            ),
          ),
          Text(_lesson.getTime()),
        ],
      ),
    );
  }
}
