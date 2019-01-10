import 'package:http/http.dart' as http;
import 'dart:convert' as converter;
import 'package:amo_schedule/weekday.dart';
import 'package:amo_schedule/models/classes.dart' as classes;
import 'package:amo_schedule/models/classroom.dart' as roomModel;
import 'package:amo_schedule/classes/lesson.dart';
import 'package:amo_schedule/classes/school_class.dart';
import 'package:amo_schedule/classes/schedule.dart';
import 'package:amo_schedule/classes/class_room.dart';
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

  // Get all the class rooms
  List<ClassRoom> rooms = await roomModel.load();

  // Convert it to json and loop
  var json = converter.json.decode(response.body);
  for (var sch in json) {
    for (var les in sch['apps']) {
      ClassRoom room;
      for (var atts in les['atts']) {
        for (ClassRoom singleRoom in rooms) {
          if (room != null) {
            break;
          }
          if (singleRoom.id == atts.toString()) {
            room = singleRoom;
            break;
          }
        }
      }
      schedule.lessons.add(
        Lesson(
          name: les['summary'],
          startTime: DateTime.parse(les['iStart']),
          endTime: DateTime.parse(les['iEnd']),
          summary: les['name'],
          classRoom: room
        ),
      );
    }
  }

  return schedule;
}
