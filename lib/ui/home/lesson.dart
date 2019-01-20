import 'package:flutter/material.dart';
import 'package:amo_schedule/classes/lesson.dart' as les;
import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/ui/static_text.dart';

class Lesson extends StatelessWidget {
  final les.Lesson _lesson;

  Lesson(this._lesson);

  Widget underTile(Group group, TextAlign align) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
        ),
        child: Text(
          (group != null) ? group.name : '-',
          textAlign: align,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

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
                  _lesson.name ?? _lesson.summary ?? StaticText.blame,
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
              underTile(_lesson.classRoom, TextAlign.left),
              underTile(_lesson.teacher, TextAlign.center),
              underTile(_lesson.schoolClass, TextAlign.right),
            ],
          ),
        ],
      ),
    );
  }
}
