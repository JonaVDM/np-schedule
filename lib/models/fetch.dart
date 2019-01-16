import 'package:amo_schedule/classes/group.dart';
import 'package:amo_schedule/models/local_file.dart';
import 'package:amo_schedule/models/api.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Fetch {
  Future<List<Group>> rooms() async {
    return fetch(LocalFile.rooms, Api.room);
  }

  Future<List<Group>> teachers() async {
    return fetch(LocalFile.teachers, Api.teacher);
  }

  Future<List<Group>> classes() async {
    return fetch(LocalFile.classes, Api.group);
  }

  Future<http.Response> schedule(String id) async {
    return Api.get(Api.schedule + id);
  }

  Future<List<Group>> fetch(String file, String url) async {
    // Create the list for return
    List<Group> group = [];

    // Load the file & check if it exists
    File _localFile = await LocalFile.file(file);
    bool exists = await _localFile.exists();

    String content;
    if (!exists) {
      http.Response response = await Api.get(url);
      _localFile.writeAsString(response.body);
      content = response.body;
    } else {
      content = await _localFile.readAsString();
    }
    // Decode the content
    var _json = json.decode(content);

    // Add all the items to the return group
    for (var teacher in _json) {
      group.add(Group.fromJson(teacher));
    }

    return group;
  }
}

