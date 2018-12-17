import 'package:flutter/material.dart';
import 'package:amo_schedule/models/schedule.dart' as Model;

class Lesson extends StatelessWidget {
  final Model.Lesson _lesson;

  Lesson(this._lesson);

  @override
  Widget build(BuildContext context) {
    List<String> _days = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];

    return Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 7.0,
      ),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 15.0,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 190.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _lesson.name ?? _lesson.summary ?? 'Blame the def',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _lesson.classRoom,
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        _days[_lesson.startTime.weekday],
                      ),
                      Container(width: 5.0),
                      Text(
                        _lesson.getTime(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
