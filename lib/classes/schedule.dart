import 'package:amo_schedule/classes/lesson.dart';
import 'package:amo_schedule/classes/day.dart';
import 'package:amo_schedule/classes/group.dart';

class Schedule {
  List<Lesson> lessons;
  Group group;
  List<Day> days;
  int today = 0;

  Schedule({this.group, this.days});

  int todayIndex() {
    return this.today;
  }
}
