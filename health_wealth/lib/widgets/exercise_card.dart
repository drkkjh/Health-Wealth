import 'package:flutter/material.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/screens/workoutbuddy/update_exercise_panel.dart';
import 'package:health_wealth/services/database.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final _db = DatabaseService();

  final List<String> exerciseIcons = [
    'assets/empty.png',
    'assets/icon-pushups.png',
    'assets/icon-situps.png',
    'assets/icon-pullups.png',
    'assets/icon-squats.png',
    'assets/icon-dumbbell.png',
    'assets/icon-benchpress.png',
    'assets/icon-deadlift.png',
    'assets/icon-running.png',
  ];

  ExerciseCard({Key? key, required this.exercise}) : super(key: key);

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

    Future _openDialog() {
      return showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Change icon'),
            content: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.75,
                width: MediaQuery.of(context).size.width * 0.75,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    crossAxisCount: 4,
                  ),
                  itemCount: exerciseIcons.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await _db
                            .changeExerciseIcon(exercise, index)
                            .whenComplete(() => Navigator.pop(dialogContext));
                      },
                      child: Image.asset(exerciseIcons[index]),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
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
                child: GestureDetector(
                    onTap: _openDialog,
                    child: exercise.iconIndex >= 0 // has icon set
                        ? Image.asset(exerciseIcons[exercise.iconIndex])
                        : Image.asset(exerciseIcons[
                            exercise.defaultIconIndex]) // no icon set
                    ),
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox(width: 30)),
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
