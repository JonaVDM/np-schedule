import 'package:http/http.dart' as http;
import 'dart:convert' as converter;
import 'package:amo_schedule/weekday.dart';
import 'package:amo_schedule/models/classes.dart' as classes;
import 'package:amo_schedule/classes/lesson.dart';
import 'package:amo_schedule/classes/school_class.dart';
import 'package:amo_schedule/classes/schedule.dart';
import 'package:amo_schedule/api.dart' as api;

String _ids(String id) {
  return "?ids%5B0%5D=4_2018_${weekday(DateTime.now())}_$id";
}

Future<Schedule> fetch() async {
  // Load in the preffered class
  SchoolClass schoolClass = await classes.readSelected();

  // Load in the schedule
  http.Response response = await http.get(api.schedule + _ids(schoolClass.id), headers: api.header);

  // Create the schedule
  Schedule schedule = Schedule(className: schoolClass.name, lessons: []);

  var json = converter.json.decode(response.body);

  for (var sch in json) {
    for (var les in sch['apps']) {
      schedule.lessons.add(
        Lesson(
          name: les['summary'],
          startTime: DateTime.parse(les['iStart']),
          endTime: DateTime.parse(les['iEnd']),
          summary: les['name'],
        ),
      );
      // break;
    }
  }

  return schedule;
}

// Future<Schedule> fetch() async {
//   DateTime date = DateTime.now();
//   var c = await model.read();
//   String classId = (c == null) ? '4013' : c.id;
//   String id1 = 'ids%5B0%5D=4_${date.year}_${weekday(DateTime.now()) - 1}_$classId';
//   String id2 = 'ids%5B1%5D=4_${date.year}_${weekday(DateTime.now())}_$classId';
//   String id3 = 'ids%5B2%5D=4_${date.year}_${weekday(DateTime.now()) + 1}_$classId';
//   List<classRoomModel.ClassRoom> rooms = await classRoomModel.load();

//   http.Response res = await http.get('${api.schedule}?$id1&$id2&$id3', headers: {
//     'Cookie': api.cookie
//   });

//   Schedule schedule = Schedule(className: (c != null) ? c.name : 'amo17_2kun', lessons: []);
//   var _json = json.decode(res.body);
//   for (var _l in _json) {
//     var apps = _l['apps'];
//     classRoomModel.ClassRoom ro;
//     for (var l in apps) {
//       for (var codes in l['atts']) {
//         for (var c in rooms) {
//           if (c.id == codes.toString()) {
//             ro = c;
//             break;
//           }
//         }
//       }
//       schedule.lessons.add(Lesson(
//         name: l['summary'],
//         summary: l['name'],
//         startTime: DateTime.parse(l['iStart']),
//         endTime: DateTime.parse(l['iEnd']),
//         classRoom: ro,
//       ));
//     }
//   }
//   return schedule;
// }
