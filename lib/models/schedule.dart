import 'package:http/http.dart' as http;

class Schedule {
  List<Lesson> lessons;
  List<List<Lesson>> days;
  String className;
  Schedule({this.lessons, this.className, this.days});

  List<List<Lesson>> perDay() {
    List<List<Lesson>> _lessons = [];
  }
}

class Lesson {
  String name;
  String classRoom;
  DateTime startTime;
  DateTime endTime;

  Lesson({this.name, this.classRoom, this.startTime, this.endTime});

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
  DateTime startTime;
  DateTime endTime;

  RegExp endRegex = RegExp('END:VEVENT');
  RegExp locationRegex = RegExp('LOCATION:([0-2][.][0-9]{2}|)');
  RegExp nameRegex = RegExp('DESCRIPTION:([a-zA-Z ()]+)');
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
      ));
      name = null;
      classRoom = null;
      startTime = null;
      endTime = null;
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
    }
  }

  lessons.sort((a,b) {
    return a.startTime.compareTo(b.startTime);
  });

  return Schedule(className: 'amo17', lessons: lessons);
}
