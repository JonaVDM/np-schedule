import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:amo_schedule/file.dart';
import 'dart:convert';
import 'package:amo_schedule/api.dart' as api;

class ClassRoom {
  String code;
  String id;

  ClassRoom([
    this.code,
    this.id,
  ]);

  ClassRoom.fromJson(Map<String, dynamic> json)
      : this.code = json['code'],
        this.id = json['id'];
}

Future<List<ClassRoom>> load() async {
  List<ClassRoom> _classRooms = [];

  File f = await localFile('classrooms.txt');
  bool excist = await f.exists();

  var _json;

  if (!excist) {
    var res = await http.get(api.classRoom, headers: {'Cookie': api.cookie});
    f.writeAsString(res.body);
    _json = json.decode(res.body);
  } else {
    String contents = await f.readAsString();
    _json = json.decode(contents);
  }

  for (var j in _json) {
    _classRooms.add(ClassRoom.fromJson(j));
  }

  return _classRooms;
}
