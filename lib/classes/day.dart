import 'package:amo_schedule/classes/lesson.dart';
import 'package:amo_schedule/string_times.dart' as StringTimes;

class Day {
  List<Lesson> lessons = [];
  DateTime date;

  Day(this.date);

  void add(Lesson les) {
    lessons.add(les);
  }

  @override
  String toString() => '${StringTimes.days[date.weekday]} ${date.day} ${StringTimes.months[date.month]} ${date.year}';
}
