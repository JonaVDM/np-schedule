import 'package:amo_schedule/classes/teacher.dart';
import 'package:amo_schedule/file.dart';
import 'package:amo_schedule/api.dart' as api;
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Teacher>> fetch() async {
  List<Teacher> teachers = [];

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
      Teacher.fromJson(teacher)
    );
  }

  return teachers;
}
