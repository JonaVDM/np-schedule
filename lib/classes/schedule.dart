import 'package:amo_schedule/classes/lesson.dart';
import 'package:amo_schedule/classes/day.dart';
import 'package:amo_schedule/classes/group.dart';

class Schedule {
  List<Lesson> lessons;
  Group group;
  List<Day> days;

  Schedule({this.group, this.days});

  int todayIndex() {
    var today = DateTime.now();
    int i = 0;
    for (Day day in days) {
      if (day.date.year == today.year &&
          day.date.month == today.month &&
          day.date.day == today.day) {
        return i;
      }
      i++;
    }
    return i;
  }
}
