import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:amo_schedule/file.dart';

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

  try {
    http.Response req =
        await http.get(url, headers: {'Cookie': 'User=$userId'});
    var _json = json.decode(req.body);
    for (var j in _json) {
      classes.add(SchoolClass.fromJson(j));
    }
  } catch (e) {
    print(e);
  }

  return classes;
}

Future<File> save(SchoolClass c) async {
  File file = await localFile('class-selected.txt');
  return file.writeAsString('${c.id}\n${c.name}');
}

Future<SchoolClass> read() async {
  try {
    File file = await localFile('class-selected.txt');
    String contents = await file.readAsString();
    var c = contents.split('\n');
    if (c.length > 1) {
      return SchoolClass(c[0], c[1]);
    }
  } catch (e) {
    return null;
  }
}
