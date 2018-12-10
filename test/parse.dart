import 'package:http/http.dart' as http;
import 'package:amo_schedule/models/schedule.dart' as model;

void main(List<String> args) {
  http.get('http://sa-nprt.xedule.nl/roster/feed?ids=4013').then(
    (response) {
      String data = response.body;
      var d = data.split('\n').toList();
      List<model.Lesson> lessons = [];

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
          lessons.add(model.Lesson(
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
    },
  );
}
