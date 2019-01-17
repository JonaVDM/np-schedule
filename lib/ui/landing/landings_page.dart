import 'package:flutter/material.dart';
import 'package:amo_schedule/ui/select/select_page.dart';
import 'package:amo_schedule/classes/group.dart';

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
              'Welkom!',
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
                child: Text('Klas'),
                onPressed: () => openPage(Group.classes),
              ),
              Container(
                width: 10.0,
              ),
              RaisedButton(
                child: Text('Docent'),
                onPressed: () => openPage(Group.teachers),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
