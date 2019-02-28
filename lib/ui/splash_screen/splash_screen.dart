import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:np_schedule/stores/schedule/store.dart';
import 'dart:async';

class SpalshScreen extends StatefulWidget {
  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen>
    with StoreWatcherMixin<SpalshScreen> {
  ScheduleStore store;

  void startTimer() {
    Duration _duration = new Duration(seconds: 5);
    Timer(_duration, switchToHome);
  }

  @override
  void initState() {
    super.initState();
    store = listenToStore(scheduleStoreToken, checkStore);
    startTimer();
  }

  void switchToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void checkStore(Store s) {
    setState(() {
      if (store != null && store.classes != null) {
        switchToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Image.asset('assets/logo/logo-red.png'),
        ),
      ),
    );
  }
}
