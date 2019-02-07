import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/util/local_file.dart';
import 'package:np_schedule/util/request.dart';

Future<List<Group>> fetchGroup(String file, String url) async {
  // The list for the return
  List<Group> group = [];

  File _localFile = await localFile(file);
  bool _exists = await _localFile.exists();

  String _content;
  if (!_exists) {
    http.Response _response = await request(url);
    _content = _response.body;
    _localFile.writeAsString(_content);
  } else {
    _content = _localFile.readAsStringSync();
  }

  var _json = json.decode(_content);

  for (var teacher in _json) {
    group.add(Group.fromJson(teacher));
  }

  return group;
}
