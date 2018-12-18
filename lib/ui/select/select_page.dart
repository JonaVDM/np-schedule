import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  final Container _divider = Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Divider(),
  );

  ListTile selection(BuildContext context, String name) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            selection(context, 'Amo16'),
            _divider,
            selection(context, 'Amo17'),
            _divider,
            selection(context, 'Amo18'),
          ],
        ),
      ),
    );
  }
}
