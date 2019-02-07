import 'package:np_schedule/classes/schedule.dart' as school;
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/models/selected.dart';
import 'package:np_schedule/util/weeknumber.dart';
import 'package:np_schedule/models/fetch.dart';
import 'package:np_schedule/classes/lesson.dart';
import 'package:np_schedule/classes/day.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Schedule {
  String _ids(String id) {
    int weekNumber = weeknumber(DateTime.now());
    if (DateTime.now().weekday == 1) {
      weekNumber += 1;
    }
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
    Fetch fetch = new Fetch();
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
        schedule.days[dayIndex].lessons
            .sort((a, b) => a.startTime.compareTo(b.startTime));
      }
    }
    schedule.days.sort((a, b) => a.date.compareTo(b.date));

    // Add in empty days & set the date index of today
    if (schedule.days.length > 0) {
      // get the day of today
      DateTime today = DateTime.now();
      today = DateTime(today.year, today.month, today.day);

      // Get the current day to the start of the schedule (Starts on sunday)
      DateTime currentDate = today.subtract(Duration(days: today.weekday + 7));

      // Set the current day
      schedule.today = 7 + today.weekday;

      // Go to all the days, yeey
      for (int i = 0; i < 21; i++) {
        if (i >= schedule.days.length) {
          // if the day is greater then the latest
          schedule.days.add(Day(currentDate));
        } else if (schedule.days[i].date != currentDate) {
          // Does the day exist
          schedule.days.add(Day(currentDate));
          schedule.days.sort((a, b) => a.date.compareTo(b.date));
        }

        // Add one day to it for the next check
        currentDate = currentDate.add(Duration(days: 1));
      }
    }

    return schedule;
  }
}
