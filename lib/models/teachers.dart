import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/file.dart';
import 'package:amo_schedule/api.dart' as api;
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Group>> fetch() async {
  List<Group> teachers = [];

  File file = await localFile('taechers.txt');
  bool excists = await file.exists();

  String content;
  if (!excists) {
    http.Response response = await http.get(api.teacher, headers: api.header);
    file.writeAsString(response.body);
    content = response.body;
  } else {
    content = await file.readAsString();
  }
  var _json = json.decode(content);

  for (var teacher in _json) {
    teachers.add(
      Group.fromJson(teacher)
    );
  }

  return teachers;
}

Future<void> saveSelected(Group teacher) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('className', teacher.name);
  prefs.setString('classId', teacher.id);
}
