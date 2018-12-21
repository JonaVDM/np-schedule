import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:amo_schedule/string_times.dart' as stringTimes;
import 'package:amo_schedule/weekday.dart';
import 'package:amo_schedule/models/classes.dart' as model;
import 'package:amo_schedule/models/classroom.dart' as classRoomModel;

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

class Day {
  List<Lesson> lessons = [];
  DateTime date;

  Day(this.date);

  void add(Lesson les) {
    lessons.add(les);
  }

  @override
  String toString() => '${stringTimes.days[date.weekday]} ${date.day} ${stringTimes.months[date.month]} ${date.year}';
}

class Lesson {
  String name;
  String summary;
  classRoomModel.ClassRoom classRoom;
  DateTime startTime;
  DateTime endTime;

  Lesson({
    this.name,
    this.classRoom,
    this.startTime,
    this.endTime,
    this.summary,
  });

  String getTime() {
    String startHour = ((startTime.hour < 10) ? '0' : '') + startTime.hour.toString();
    String startMinute = ((startTime.minute < 10) ? '0' : '') + startTime.minute.toString();
    String endHour = ((endTime.hour < 10) ? '0' : '') + endTime.hour.toString();
    String endMinute = ((endTime.minute < 10) ? '0' : '') + endTime.minute.toString();
    return '$startHour:$startMinute-$endHour:$endMinute';
  }
}

Future<Schedule> fetch() async {
  DateTime date = DateTime.now();
  model.SchoolClass c = await model.read();
  String classId = (c == null) ? '4013' : c.id;
  String apiKey = '1f043ffb-68c4-4bf4-ab14-55cf0f500e9e';
  String url = 'https://sa-nprt.xedule.nl/api/schedule/';
  String id1 = 'ids%5B0%5D=4_${date.year}_${weekday(DateTime.now()) - 1}_$classId';
  String id2 = 'ids%5B1%5D=4_${date.year}_${weekday(DateTime.now())}_$classId';
  String id3 = 'ids%5B2%5D=4_${date.year}_${weekday(DateTime.now()) + 1}_$classId';
  List<classRoomModel.ClassRoom> rooms = await classRoomModel.load();

  http.Response res = await http.get('$url?$id1&$id2&$id3', headers: {
    'Cookie': 'User=$apiKey',
  });
  Schedule schedule = Schedule(className: (c != null) ? c.name : 'amo17_2kun', lessons: []);

  var _json = json.decode(res.body);
  for (var _l in _json) {
    var apps = _l['apps'];
    classRoomModel.ClassRoom ro;
    for (var l in apps) {
      for (var codes in l['atts']) {
        for (var c in rooms) {
          if (c.id == codes.toString()) {
            ro = c;
            break;
          }
        }
      }
      schedule.lessons.add(Lesson(
        name: l['summary'],
        summary: l['name'],
        startTime: DateTime.parse(l['iStart']),
        endTime: DateTime.parse(l['iEnd']),
        classRoom: ro,
      ));
    }
  }
  return schedule;
}
