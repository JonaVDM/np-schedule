import 'package:amo_schedule/classes/lesson.dart';
import 'package:amo_schedule/classes/day.dart';

class Schedule {
  List<Lesson> lessons;
  String className;
  Schedule({this.lessons, this.className});

  List<Day> perDay() {
    List<Day> days = [];
    for (var les in lessons) {
      var date = DateTime(
        les.startTime.year,
        les.startTime.month,
        les.startTime.day,
      );
      Day _d;
      for (var day in days) {
        if (day.date == date) {
          _d = day;
          days.removeWhere((d) => d.date == date);
          break;
        }
      }
      if (_d == null) _d = Day(date);
      _d.add(les);
      days.add(_d);
    }
    days.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    return days;
  }
}
