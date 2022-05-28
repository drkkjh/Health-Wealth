import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Workout {
  String? name;
  int? days;

  Workout(String name, int days) {
    this.name = name;
    this.days = days;
  }
}
