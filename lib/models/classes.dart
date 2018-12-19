import 'package:http/http.dart' as http;
import 'dart:convert';

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
    http.Response req = await http.get(url, headers: {'Cookie': 'User=$userId'});
    var _json = json.decode(req.body);
    for (var j in _json) {
      classes.add(SchoolClass.fromJson(j));
    }
  } catch (e) {
    print(e);
  }

  return classes;
}
