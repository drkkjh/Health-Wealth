import 'package:flutter/material.dart';
import 'package:health_wealth/model/workout.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  const WorkoutCard({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        Text(
          workout.name.toString(),
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6.0),
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
