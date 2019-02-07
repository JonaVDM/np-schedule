import 'package:http/http.dart' as http;
import 'dart:async';

class Api {
  static String domain = 'https://sa-nprt.xedule.nl';
  static String cookie = 'User=1f043ffb-68c4-4bf4-ab14-55cf0f500e9e';

  static String room = '$domain/api/facility/';
  static String schedule = '$domain/api/schedule';
  static String group = '$domain/api/group/';
  static String teacher = '$domain/api/docent/';

  static Map<String, String> header = {
    'Cookie': cookie,
  };

  static Future<http.Response> get(url) {
    return http.get(url, headers: header);
  }
}
