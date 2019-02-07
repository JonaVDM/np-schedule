import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

Future<File> localFile(String file) async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$file');
}
