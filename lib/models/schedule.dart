import 'package:http/http.dart' as http;

class Schedule {
  List<Lesson> lessons;
  String className;
  Schedule({this.lessons, this.className});

  List<Day> perDay() {
    List<Day> days = [];
    for (var les in lessons) {
      var date = DateTime(les.startTime.year, les.startTime.month, les.startTime.day);
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
    days.sort((a,b) {
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
}

class Lesson {
  String name;
  String summary;
  String classRoom;
  DateTime startTime;
  DateTime endTime;

  Lesson({this.name, this.classRoom, this.startTime, this.endTime, this.summary});

  getTime() {
    return ((startTime.hour < 10) ? '0' : '') +
        startTime.hour.toString() +
        ':' +
        ((startTime.minute < 10) ? '0' : '') +
        startTime.minute.toString() +
        ' - ' +
        ((endTime.hour < 10) ? '0' : '') +
        endTime.hour.toString() +
        ':' +
        ((endTime.minute < 10) ? '0' : '') +
        endTime.minute.toString();
  }
}

Future<Schedule> fetch() async {
  var url = 'http://sa-nprt.xedule.nl/roster/feed?ids=4013';
  var req = await http.get(url);
  String data = req.body;
  var d = data.split('\n').toList();
  List<Lesson> lessons = [];

  String name;
  String classRoom;
  String summary;
  DateTime startTime;
  DateTime endTime;

  RegExp endRegex = RegExp('END:VEVENT');
  RegExp locationRegex = RegExp('LOCATION:([0-2][.][0-9]{2}|)');
  RegExp nameRegex = RegExp('DESCRIPTION:([a-zA-Z ()]+)');
  RegExp summarayRegex = RegExp('SUMMARY:([a-zA-Z0-9]+)');
  RegExp startTimeRegex =
      RegExp('DTSTART;TZID=W. Europe Standard Time:([0-9]{8}T[0-9]{6})');
  RegExp endTimeRegex =
      RegExp('DTEND;TZID=W. Europe Standard Time:([0-9]{8}T[0-9]{6})');

  for (var i in d) {
    if (endRegex.hasMatch(i)) {
      lessons.add(Lesson(
        name: name,
        classRoom: classRoom,
        startTime: startTime,
        endTime: endTime,
        summary: summary,
      ));
      name = null;
      classRoom = null;
      startTime = null;
      endTime = null;
      summary = null;
    } else if (locationRegex.hasMatch(i)) {
      Iterable<Match> matches = locationRegex.allMatches(i);
      for (var m in matches) {
        classRoom = m.group(1);
      }
    } else if (nameRegex.hasMatch(i)) {
      Iterable<Match> matches = nameRegex.allMatches(i);
      for (var m in matches) {
        name = m.group(1);
      }
    } else if (startTimeRegex.hasMatch(i)) {
      Iterable<Match> matches = startTimeRegex.allMatches(i);
      for (var m in matches) {
        startTime = DateTime.parse(m.group(1));
      }
    } else if (endTimeRegex.hasMatch(i)) {
      Iterable<Match> matches = endTimeRegex.allMatches(i);
      for (var m in matches) {
        endTime = DateTime.parse(m.group(1));
      }
    } else if (summarayRegex.hasMatch(i)) {
      Iterable<Match> matches = summarayRegex.allMatches(i);
      for (var m in matches) {
        summary = m.group(1);
      }
    }
  }

  lessons.sort((a,b) {
    return a.startTime.compareTo(b.startTime);
  });

  return Schedule(className: 'amo17', lessons: lessons);
}
