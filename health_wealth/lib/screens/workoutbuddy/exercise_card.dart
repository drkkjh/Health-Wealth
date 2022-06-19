import 'package:flutter/material.dart';
import 'package:health_wealth/model/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final List<String> exerciseIcons = [
    'assets/icon-pushups.png',
    'assets/icon-situps.png',
    'assets/icon-pullups.png',
    'assets/icon-squats.png',
    'assets/icon-dumbbell.png'
  ];

  ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 1),
              child: SizedBox(
                height: 40,
                width: 30,
                child: Image.asset(exerciseIcons[exercise.iconIndex]),
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox.shrink()),
          // const SizedBox(width: 5),
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 70,
          ),
          Expanded(
            flex: 2,
            child: Text(
              exercise.sets.toString(),
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              exercise.reps.toString(),
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
