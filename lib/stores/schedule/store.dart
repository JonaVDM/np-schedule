import 'dart:async';
import 'dart:convert';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/classes/schedule.dart';
import 'package:np_schedule/classes/day.dart';
import 'package:np_schedule/classes/lesson.dart';
import 'package:np_schedule/util/fetch_group.dart';
import 'package:np_schedule/util/api_url.dart' as url;
import 'package:np_schedule/util/file_name.dart' as file;
import 'package:np_schedule/util/weeknumber.dart';
import 'package:np_schedule/util/request.dart';

class ScheduleStore extends Store {
  List<Group> _classes = [];
  List<Group> _teachers = [];
  List<Group> _rooms = [];
  List<Group> _recent = [];

  SharedPreferences _preferences;

  Group _selected;

  Schedule _schedule;

  ScheduleStore() {
    this._loadAll();
    triggerOnAction(reloadAllAction, (nothing) => this._loadAll());
    triggerOnAction(reloadClassesAction, (nothing) => this._loadClasses());
    triggerOnAction(reloadTeachersAction, (nothing) => this._loadTeachers());
    triggerOnAction(reloadRoomsAction, (nothing) => this._loadRooms());
    triggerOnAction(saveGroup, _saveSelected);
    triggerOnAction(reloadSchedule, (nothing) => this._loadSchedule());
  }

  String _ids() {
    List<String> weeks = [];
    int week = weeknumber(DateTime.now());
    int year = 2018; // Don't ask me okay
    for (int i = week - 1, j = 0; i <= week + 1; i++, j++) {
      weeks.add('ids[$j]=4_${year}_${i}_${_selected.id}');
    }
    return '?${weeks.join('&')}';
  }

  Group _compare(List<Group> groups, String selector) {
    for (Group single in groups) {
      if (single.id == selector) {
        return single;
      }
    }
    return null;
  }

  Future<void> _loadSchedule() async {
    Schedule schedule = Schedule(group: _selected, days: []);
    http.Response response = await request(url.schedule + _ids());

    for (var sch in json.decode(response.body)) {
      for (var les in sch['apps']) {
        Group teacher, schoolClass, room;
        String name = les['summary'];
        String summary = les['name'];
        DateTime start = DateTime.parse(les['iStart']);
        DateTime stop = DateTime.parse(les['iEnd']);
        DateTime date = DateTime(start.year, start.month, start.day);
        int dayIndex;
        for (var atts in les['atts']) {
          // Class room
          if (room == null) {
            room = _compare(_rooms, atts.toString());
          }

          // Teacher
          if (teacher == null) {
            teacher = _compare(_teachers, atts.toString());
          }

          // Class
          if (schoolClass == null) {
            schoolClass = _compare(_classes, atts.toString());
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

    trigger();
    this._schedule = schedule;
  }

  // Setters/loader
  void _loadAll() async {
    await this._loadPreferences();
    await this._loadClasses();
    await this._loadTeachers();
    await this._loadRooms();
    await this._loadRecent();
    await this._loadSelected();
    if (this._selected != null) {
      await this._loadSchedule();
    }
    trigger();
  }

  Future<void> _loadClasses() async {
    this._classes = await fetchGroup(file.classes, url.classes);
  }

  Future<void> _loadTeachers() async {
    this._teachers = await fetchGroup(file.teachers, url.teachers);
  }

  Future<void> _loadRooms() async {
    this._rooms = await fetchGroup(file.rooms, url.rooms);
  }

  Future<void> _loadSelected() async {
    String name = this._preferences.getString('group_name') ?? 'ha nee';
    String id = this._preferences.getString('group_id') ?? 'ha nee';
    if (name != 'ha nee' && id != 'ha nee') {
      this._selected = Group(id, name);
    }
  }

  Future<void> _loadPreferences() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  Future<void> _loadRecent() async {
    _recent = [];
    List<Group> all = [];
    List<String> recent = _preferences.getStringList('recent_items') ?? [];
    all.addAll(_classes);
    all.addAll(_teachers);
    all.addAll(_rooms);
    for (String rec in recent) {
      for (Group single in all) {
        if (single.id == rec) {
          _recent.add(single);
        }
        if (_recent.length == recent.length) return;
      }
    }
  }

  Future<void> _saveSelected(Group group) async {
    _recent.remove(group);
    _recent.insert(0, group);
    if (_recent.length > 5) _recent.removeLast();
    List<String> recent = _recent.map((Group g) => g.id).toList();
    this._preferences.setString('group_name', group.name);
    this._preferences.setString('group_id', group.id);
    this._preferences.setStringList('recent_items', recent);
    this._selected = group;
    this._schedule = null;
    trigger();
    this._loadSchedule();
    trigger();
  }

  // Getters
  List<Group> get classes => List<Group>.unmodifiable(_classes);
  List<Group> get teachers => List<Group>.unmodifiable(_teachers);
  List<Group> get rooms => List<Group>.unmodifiable(_rooms);
  List<Group> get recent => List<Group>.unmodifiable(_recent);
  Group get selected => _selected;
  Schedule get schedule => _schedule;
}

// Token
final StoreToken scheduleStoreToken = StoreToken(ScheduleStore());

// Actions
final Action<void> reloadAllAction = Action<void>();
final Action<void> reloadClassesAction = Action<void>();
final Action<void> reloadTeachersAction = Action<void>();
final Action<void> reloadRoomsAction = Action<void>();
final Action<Group> saveGroup = Action<Group>();
final Action<void> reloadSchedule = Action<void>();
final Action<void> switchStarSchedule = Action<void>();
