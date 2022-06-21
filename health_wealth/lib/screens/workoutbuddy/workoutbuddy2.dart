// *This page has swipe to delete features. Not linked to backend.
//* In order to undo deletes, the deleted Exercise will have to be stored in a variable.

import 'package:flutter/material.dart';
import 'package:health_wealth/common/loading.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/screens/workoutbuddy/exercise_card.dart';
import 'package:health_wealth/services/database.dart';

class WorkOutBuddy2 extends StatefulWidget {
  const WorkOutBuddy2({Key? key}) : super(key: key);

  @override
  State<WorkOutBuddy2> createState() => _WorkOutBuddyState();
}

class _WorkOutBuddyState extends State<WorkOutBuddy2> {
  final _db = DatabaseService();
  List<Exercise>? _exercises = [];
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  // @override
  // void initState() {
  //   super.initState();
  //   // exercises = [];
  //   refreshKey = GlobalKey<RefreshIndicatorState>();
  // }

  // Widget list() {
  //   return ListView.builder(
  //       padding: const EdgeInsets.all(20.0),
  //       itemCount: exerciseList.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return row(context, index);
  //       });
  // }

  // Widget row(BuildContext context, int index) {
  //   return Dismissible(
  //     key: Key(UniqueKey().toString()),
  //     onDismissed: (direction) {
  //       var workout = exercises[index];
  //       showDeleted(context, workout, index);
  //       removeExercise(index);
  //     },
  //     background: refreshBackground(),
  //     child: Card(
  //       child: ListTile(
  //         title: Text(exercises[index]),
  //       ),
  //     ),
  //   );
  // }

  Widget refreshBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      color: Colors.red[900],
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

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
                title: const Text('WorkOutBuddy2'),
                backgroundColor: Colors.lightBlue,
                actions: <Widget>[
                  FloatingActionButton(
                    heroTag: 'addWorkoutTag',
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    onPressed: () async {
                      // final workoutToAdd = await Navigator.of(context).push(
                      //   MaterialPageRoute(
                      // builder: (context) => const AddWorkOut(),
                      //   ),
                      // );
                      // setState(
                      //   () => exercises.add(workoutToAdd),
                      // );
                    },
                    child: const Icon(Icons.add),
                  )
                ],
              ),
              body: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                itemCount: _exercises!.length,
                itemBuilder: ((context, index) {
                  var ex = _exercises![index];
                  return Dismissible(
                      key: Key(ex.name),
                      onDismissed: (direction) {
                        showDeleted(context, ex, index);
                        removeExercise(index);
                        // _db.setExercises(_exercises);
                      },
                      background: refreshBackground(),
                      child: ExerciseCard(exercise: ex));
                }),
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

  void removeExercise(index) {
    setState(() {
      _exercises!.removeAt(index);
    });
  }

  void undoDelete(index, Exercise ex) {
    setState(() {
      _exercises!.insert(index, ex);
    });
  }

  void showDeleted(BuildContext context, Exercise ex, index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${ex.name} deleted'),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          undoDelete(index, ex);
        },
      ),
    ));
  }
}
