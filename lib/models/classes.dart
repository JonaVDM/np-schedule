import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:amo_schedule/file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolClass {
  String id;
  String name;

  SchoolClass(this.id, this.name);

  SchoolClass.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.name = json['code'];
}

Future<List<SchoolClass>> fetch() async {
  String url = 'https://sa-nprt.xedule.nl/api/group/';
  String userId = '1f043ffb-68c4-4bf4-ab14-55cf0f500e9e';
  List<SchoolClass> classes = [];
  File f = await localFile('classes.txt');
  bool excist = await f.exists();
  var _json;
  if (!excist) {
    try {
      http.Response req =
          await http.get(url, headers: {'Cookie': 'User=$userId'});
      f.writeAsString(req.body);
      _json = json.decode(req.body);
    } catch (e) {
      print(e);
    }
  } else {
    var contents = await f.readAsString();
    _json = json.decode(contents);
  }

  for (var j in _json) {
    classes.add(SchoolClass.fromJson(j));
  }

  return classes;
}

Future<void> save(SchoolClass c) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('classname', c.name);
  prefs.setString('classId', c.id);
}

Future<SchoolClass> read() async {
  final prefs = await SharedPreferences.getInstance();
  final className = prefs.getString('classname') ?? 'AMO17_2KUN';
  final classId = prefs.getString('classId') ?? '4013';
  return SchoolClass(classId, className);
}
