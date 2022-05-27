import 'package:flutter/material.dart';
import 'package:health_wealth/screens/home.dart';
import 'package:health_wealth/screens/snacktracker.dart';
import 'package:health_wealth/screens/workoutbuddy.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugShowCheckedModeBanner:
    false;
    return WorkOutBuddy();
  }
}
