import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:np_schedule/util/api_url.dart';

Future<http.Response> request(url) {
  return http.get(url, headers: header);
}
