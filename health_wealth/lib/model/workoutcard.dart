import 'package:flutter/material.dart';
import 'package:health_wealth/model/workout.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        Text(
          workout.name.toString(),
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 6.0),
        Text(
          workout.days.toString(),
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[600],
          ),
        ),
      ]),
    );
  }
}
