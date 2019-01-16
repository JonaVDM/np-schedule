import 'package:http/http.dart' as http;
import 'dart:convert' as converter;
import 'package:amo_schedule/weekday.dart';
import 'package:amo_schedule/models/classes.dart' as classes;
import 'package:amo_schedule/models/classroom.dart' as roomModel;
import 'package:amo_schedule/models/teachers.dart' as teacher;
import 'package:amo_schedule/classes/lesson.dart';
import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/classes/schedule.dart';
import 'package:amo_schedule/api.dart' as api;

String _ids(String id) {
  int weekNumber = weekday(DateTime.now());
  List<String> weeks = [];

  if (weekNumber == 1) weeks.add('ids[0]=4_2018_51_$id');
  else weeks.add('ids[0]=4_2018_${weekNumber - 1}_$id');
  weeks.add('ids[1]=4_2018_${weekNumber}_$id');
  if (weekNumber == 52) weeks.add('ids[2]=4_2018_1_$id');
  else weeks.add('ids[2]=4_2018_${weekNumber + 1}_$id');

  return '?' + weeks.join('&');
}

Future<Schedule> fetch() async {
  // Load in the preffered class
  Group schoolClass = await classes.readSelected();

  // Load in the schedule
  http.Response response =
      await http.get(api.schedule + _ids(schoolClass.id), headers: api.header);

  // Create the schedule
  Schedule schedule = Schedule(className: schoolClass.name, lessons: []);

  // Get a list of all the classrooms & teachers & classes
  List<Group> rooms = await roomModel.load();
  List<Group> teachers = await teacher.fetch();
  List<Group> schoolClasses = await classes.fetch();

  // Convert it to json and loop
  var json = converter.json.decode(response.body);
  for (var sch in json) {
    for (var les in sch['apps']) {
      Group teacher, schoolClass, room;
      for (var atts in les['atts']) {
        if (room == null) {
          for (Group singleRoom in rooms) {
            if (singleRoom.id == atts.toString()) {
              room = singleRoom;
              break;
            }
          }
        }
        if (teacher == null) {
          for (Group t in teachers) {
            if (t.id == atts.toString()) {
              teacher = t;
              break;
            }
          }
        }
        if (schoolClass == null) {
          for (Group c in schoolClasses) {
            if (c.id == atts.toString()) {
              schoolClass = c;
              break;
            }
          }
        }
      }
      schedule.lessons.add(
        Lesson(
          name: les['summary'],
          startTime: DateTime.parse(les['iStart']),
          endTime: DateTime.parse(les['iEnd']),
          summary: les['name'],
          teacher: teacher,
          classRoom: room,
          schoolClass: schoolClass,
        ),
      );
    }
  }

  return schedule;
}
