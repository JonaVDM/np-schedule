import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:amo_schedule/file.dart';
import 'dart:convert';
import 'package:amo_schedule/api.dart' as api;
import 'package:amo_schedule/classes/group.dart';

Future<List<Group>> load() async {
  List<Group> _classRooms = [];

  File f = await localFile('classrooms.txt');
  bool excist = await f.exists();

  var _json;

  if (!excist) {
    var res = await http.get(api.classRoom, headers: api.header);
    f.writeAsString(res.body);
    _json = json.decode(res.body);
  } else {
    String contents = await f.readAsString();
    _json = json.decode(contents);
  }

  for (var j in _json) {
    _classRooms.add(Group.fromJson(j));
  }

  return _classRooms;
}
