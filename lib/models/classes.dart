import 'package:http/http.dart' as http;
import 'package:amo_schedule/classes/group.dart';
import 'dart:convert';
import 'dart:io';
import 'package:amo_schedule/file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amo_schedule/api.dart' as api;

Future<List<Group>> fetch() async {
  List<Group> classes = [];

  File file = await localFile('classes.txt');
  bool excist = await file.exists();

  var _json;
  if (!excist) {
    http.Response res = await http.get(api.group, headers: api.header);
    file.writeAsString(res.body);
    _json = json.decode(res.body);
  } else {
    String contents = await file.readAsString();
    _json = json.decode(contents);
  }

  for (var j in _json) {
    classes.add(Group.fromJson(j));
  }

  return classes;
}

Future<void> saveSelected(Group schoolClass) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('className', schoolClass.name);
  prefs.setString('classId', schoolClass.id);
}

Future<Group> readSelected() async {
  final prefs = await SharedPreferences.getInstance();
  final className = prefs.getString('className') ?? 'AMO17_2KUN';
  final classId = prefs.getString('classId') ?? '4013';
  return Group(classId, className);
}
