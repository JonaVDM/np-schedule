import 'package:amo_schedule/classes/group.dart';

class Lesson {
  String name;
  String summary;
  Group classRoom;
  DateTime startTime;
  DateTime endTime;
  Group teacher;
  Group schoolClass;

  Lesson({
    this.name,
    this.classRoom,
    this.startTime,
    this.endTime,
    this.summary,
    this.teacher,
    this.schoolClass
  });

  String getTime() {
    String startHour = ((startTime.hour < 10) ? '0' : '') + startTime.hour.toString();
    String startMinute = ((startTime.minute < 10) ? '0' : '') + startTime.minute.toString();
    String endHour = ((endTime.hour < 10) ? '0' : '') + endTime.hour.toString();
    String endMinute = ((endTime.minute < 10) ? '0' : '') + endTime.minute.toString();
    return '$startHour:$startMinute-$endHour:$endMinute';
  }
}
