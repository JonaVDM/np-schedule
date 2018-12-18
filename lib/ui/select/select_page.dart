import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  final Container _divider = Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Divider(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Amo16'),
            ),
            _divider,
            ListTile(
              title: Text('Amo17'),
            ),
            _divider,
            ListTile(
              title: Text('Amo18'),
            ),
          ],
        ),
      ),
    );
  }
}
