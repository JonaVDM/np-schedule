import 'package:flutter/material.dart';
import 'package:np_schedule/ui/select/select_page.dart';
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/ui/static_text.dart';

class LandingsPage extends StatelessWidget {
  final VoidCallback callback;

  LandingsPage(this.callback);

  @override
  Widget build(BuildContext context) {
    void openPage(int target) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
          return SelectPage(callback, target);
        }),
      );
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              StaticText.welcome,
              style: TextStyle(
                fontSize: 28.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(StaticText.classes),
                onPressed: () => openPage(Group.classes),
              ),
              Container(
                width: 10.0,
              ),
              RaisedButton(
                child: Text(StaticText.teachers),
                onPressed: () => openPage(Group.teachers),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
