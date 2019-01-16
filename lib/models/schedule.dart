import 'package:amo_schedule/classes/schedule.dart' as school;
import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/models/selected.dart';
import 'package:amo_schedule/weekday.dart';
import 'package:amo_schedule/models/fetch.dart';
import 'package:amo_schedule/classes/lesson.dart';
import 'package:amo_schedule/classes/day.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Schedule {
  String _ids(String id) {
    int weekNumber = weekday(DateTime.now());
    List<String> weeks = [];

    if (weekNumber == 1)
      weeks.add('ids[0]=4_2018_51_$id');
    else
      weeks.add('ids[0]=4_2018_${weekNumber - 1}_$id');
    weeks.add('ids[1]=4_2018_${weekNumber}_$id');
    if (weekNumber == 52)
      weeks.add('ids[2]=4_2018_1_$id');
    else
      weeks.add('ids[2]=4_2018_${weekNumber + 1}_$id');

    return '?' + weeks.join('&');
  }

   Future<school.Schedule> fetch() async {
    // Load the selected group
    Selected selected = new Selected();
    Group group = await selected.load();

    // Load the schedule for the group
    Fetch fetch =  new Fetch();
    http.Response response = await fetch.schedule(_ids(group.id));

    // Get a list of all the classrooms & teachers & classes
    List<Group> rooms = await fetch.rooms();
    List<Group> teachers = await fetch.teachers();
    List<Group> classes = await fetch.classes();

    // Create the schedule
    school.Schedule schedule = school.Schedule(group: group, days: []);

    // Convert to json and loop
    for (var sch in json.decode(response.body)) {
      for (var les in sch['apps']) {
        Group teacher, schoolClass, room;
        String name = les['summary'];
        String summary = les['name'];
        DateTime start = DateTime.parse(les['iStart']);
        DateTime stop = DateTime.parse(les['iEnd']);
        DateTime date = DateTime(start.year, start.month, start.day);
        int dayIndex;

        // Finding stuff for the class
        for (var atts in les['atts']) {
          // Class room
          if (room == null) {
            for (Group singleRoom in rooms) {
              if (singleRoom.id == atts.toString()) {
                room = singleRoom;
                break;
              }
            }
          }

          // Teacher
          if (teacher == null) {
            for (Group t in teachers) {
              if (t.id == atts.toString()) {
                teacher = t;
                break;
              }
            }
          }

          // Class
          if (schoolClass == null) {
            for (Group c in classes) {
              if (c.id == atts.toString()) {
                schoolClass = c;
                break;
              }
            }
          }
        }

        // Find the day
        for (int i = 0; i < schedule.days.length; i++) {
          Day day = schedule.days[i];
          if (day.date == date) {
            dayIndex = i;
            break;
          }
        }

        // Check if the date exist
        if (dayIndex == null) {
          dayIndex = schedule.days.length;
          schedule.days.add(Day(date));
        }

        // add the lesson to the day
        schedule.days[dayIndex].add(
          Lesson(
            name: name,
            startTime: start,
            endTime: stop,
            summary: summary,
            teacher: teacher,
            classRoom: room,
            schoolClass: schoolClass,
          ),
        );

        // sort the day
        schedule.days[dayIndex].lessons.sort((a, b) => a.startTime.compareTo(b.startTime));
      }
    }
    schedule.days.sort((a, b) => a.date.compareTo(b.date));
    return schedule;
  }
}

// String _ids(String id) {
//   int weekNumber = weekday(DateTime.now());
//   List<String> weeks = [];

//   if (weekNumber == 1) weeks.add('ids[0]=4_2018_51_$id');
//   else weeks.add('ids[0]=4_2018_${weekNumber - 1}_$id');
//   weeks.add('ids[1]=4_2018_${weekNumber}_$id');
//   if (weekNumber == 52) weeks.add('ids[2]=4_2018_1_$id');
//   else weeks.add('ids[2]=4_2018_${weekNumber + 1}_$id');

//   return '?' + weeks.join('&');
// }

// Future<Schedule> fetch() async {
//   // Load in the preffered class
//   Group schoolClass = await classes.readSelected();

//   // Load in the schedule
//   http.Response response =
//       await http.get(api.schedule + _ids(schoolClass.id), headers: api.header);

//   // Create the schedule
//   Schedule schedule = Schedule(className: schoolClass.name, lessons: []);

//   // Get a list of all the classrooms & teachers & classes
//   List<Group> rooms = await roomModel.load();
//   List<Group> teachers = await teacher.fetch();
//   List<Group> schoolClasses = await classes.fetch();

//   // Convert it to json and loop
//   var json = converter.json.decode(response.body);
//   for (var sch in json) {
//     for (var les in sch['apps']) {
//       Group teacher, schoolClass, room;
//       for (var atts in les['atts']) {
//         if (room == null) {
//           for (Group singleRoom in rooms) {
//             if (singleRoom.id == atts.toString()) {
//               room = singleRoom;
//               break;
//             }
//           }
//         }
//         if (teacher == null) {
//           for (Group t in teachers) {
//             if (t.id == atts.toString()) {
//               teacher = t;
//               break;
//             }
//           }
//         }
//         if (schoolClass == null) {
//           for (Group c in schoolClasses) {
//             if (c.id == atts.toString()) {
//               schoolClass = c;
//               break;
//             }
//           }
//         }
//       }
//       schedule.lessons.add(
//         Lesson(
//           name: les['summary'],
//           startTime: DateTime.parse(les['iStart']),
//           endTime: DateTime.parse(les['iEnd']),
//           summary: les['name'],
//           teacher: teacher,
//           classRoom: room,
//           schoolClass: schoolClass,
//         ),
//       );
//     }
//   }

//   return schedule;
// }
