import 'package:flutter/material.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/screens/workoutbuddy/update_exercise_panel.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  final List<String> exerciseIcons = [
    'assets/icon-pushups.png',
    'assets/icon-situps.png',
    'assets/icon-pullups.png',
    'assets/icon-squats.png',
    'assets/icon-dumbbell.png'
  ];

  @override
  Widget build(BuildContext context) {
    void _showUpdateExercisePanel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: UpdateExercisePanel(exercise: exercise),
            );
          });
    }

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
                // width: 30
                child: Image.asset(exerciseIcons[exercise.iconIndex]),
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox(width: 30)),
          // const SizedBox(width: 30),
          Expanded(
            flex: 5,
            child: SizedBox(
              width: 400,
              child: Text(
                exercise.name,
                style: const TextStyle(fontSize: 25.0),
              ),
            ),
          ),
          // const SizedBox(
          //   width: 70,
          // ),
          Expanded(
            flex: 3,
            child: TextButton(
              onPressed: _showUpdateExercisePanel,
              child: Text(
                exercise.sets.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextButton(
              onPressed: _showUpdateExercisePanel,
              child: Text(
                exercise.reps.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
