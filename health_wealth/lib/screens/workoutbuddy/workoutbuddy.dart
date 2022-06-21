import 'package:flutter/material.dart';
import 'package:health_wealth/common/loading.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/screens/workoutbuddy/exercise_card.dart';
import 'package:health_wealth/services/database.dart';

class WorkOutBuddy extends StatefulWidget {
  const WorkOutBuddy({Key? key}) : super(key: key);

  @override
  State<WorkOutBuddy> createState() => _WorkOutBuddyState();
}

class _WorkOutBuddyState extends State<WorkOutBuddy> {
  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Exercise>?>(
      initialData: const [],
      stream: _db.getExercises,
      builder: (context, snapshot) {
        final exercises = snapshot.data;

        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('WorkOutBuddy'),
              backgroundColor: Colors.lightBlue,
            ),
            // floatingActionButton: FloatingActionButton(
            //   heroTag: 'addWorkoutTag',
            //   onPressed: () async {
            //     final workoutToAdd = await Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const AddWorkOut(),
            //       ),
            //     );
            //   },
            //   child: const Icon(Icons.add),
            // ),
            body: Column(
              children: [
                const HeaderRow(),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  itemCount: exercises!.length,
                  itemBuilder: (context, index) {
                    return ExerciseCard(exercise: exercises[index]);
                  },
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
      },
    );
  }
}

class HeaderRow extends StatelessWidget {
  const HeaderRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          // SizedBox(width: 25),
          Expanded(
            flex: 1,
            child: SizedBox.shrink(),
          ),
          Expanded(
            flex: 6,
            child: Center(
              child: Text('Exercise', style: TextStyle(fontSize: 25)),
            ),
          ),
          // SizedBox(width: 30),
          Expanded(
            flex: 2,
            child: Text('Sets', style: TextStyle(fontSize: 25)),
          ),
          // SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Text('Reps', style: TextStyle(fontSize: 25)),
          ),
        ],
      ),
    );
  }
}
