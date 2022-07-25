import 'package:flutter/material.dart';
import 'package:health_wealth/screens/workoutbuddy/add_exercise.dart';
import 'package:health_wealth/widgets/loading.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/widgets/exercise_card.dart';
import 'package:health_wealth/services/database.dart';

class WorkOutBuddy extends StatefulWidget {
  const WorkOutBuddy({Key? key}) : super(key: key);

  @override
  State<WorkOutBuddy> createState() => _WorkOutBuddyState();
}

class _WorkOutBuddyState extends State<WorkOutBuddy> {
  final _db = DatabaseService();
  List<Exercise>? _exercises = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Exercise>?>(
        initialData: const [],
        stream: _db.getExercises,
        builder: (context, snapshot) {
          final exerciseList = snapshot.data;
          if (snapshot.hasData) {
            Future.delayed(Duration.zero, () async {
              setState(() {
                _exercises = exerciseList;
              });
            });
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('WorkoutBuddy'),
                backgroundColor: Colors.lightBlue,
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'addExercise',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddExercise()),
                  );
                },
                child: const Icon(Icons.add),
              ),
              body: Column(
                children: [
                  const HeaderRow(),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    itemCount: _exercises!.length,
                    itemBuilder: ((context, index) {
                      Exercise ex = _exercises![index];
                      return Dismissible(
                        key: Key(ex.name),
                        onDismissed: (direction) {
                          _showDeleted(context, ex, index);
                          _removeExercise(index);
                          _db.deleteExercise(ex);
                        },
                        background: _refreshBackground(),
                        child: ExerciseCard(exercise: ex),
                      );
                    }),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }

  Widget _refreshBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      color: Colors.red[900],
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  void _removeExercise(index) {
    setState(() {
      _exercises!.removeAt(index);
    });
  }

  void _undoDelete(index, Exercise ex) async {
    await _db.addExercise(ex);
  }

  void _showDeleted(BuildContext context, Exercise ex, index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${ex.name} deleted'),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          _undoDelete(index, ex);
        },
      ),
    ));
  }
}

class HeaderRow extends StatelessWidget {
  const HeaderRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Expanded(
            flex: 3,
            child: Center(
              child: Text('Exercise', style: TextStyle(fontSize: 25)),
            ),
          ),
          Expanded(
            child: Text('Sets', style: TextStyle(fontSize: 25)),
          ),
          Expanded(
            child: Text('Reps', style: TextStyle(fontSize: 25)),
          ),
        ],
      ),
    );
  }
}
