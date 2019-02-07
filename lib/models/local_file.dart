import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class LocalFile {
  static String rooms = 'rooms.txt';
  static String classes = 'classes.txt';
  static String teachers = 'teachers.txt';

  static Future<File> file(String file) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$file');
  }

}
