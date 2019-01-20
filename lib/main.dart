import 'package:flutter/material.dart';
import 'package:amo_schedule/ui/home/home_page.dart';
import 'package:amo_schedule/ui/static_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StaticText.title,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}
