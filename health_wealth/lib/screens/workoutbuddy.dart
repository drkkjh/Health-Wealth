import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:math';

class WorkOutBuddy extends StatefulWidget {
  const WorkOutBuddy({Key? key}) : super(key: key);

  @override
  State<WorkOutBuddy> createState() => _WorkOutBuddyState();
}

class _WorkOutBuddyState extends State<WorkOutBuddy> {
  static int len = 1;
  List<String> workouts = [];
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  Random r = Random();

  @override
  void initState() {
    super.initState();
    workouts = [];
    addWorkouts();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  addWorkouts() {
    workouts.add("Push Ups");
    workouts.add("Sit Ups");
  }

  Widget list() {
    return ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: workouts.length,
        itemBuilder: (BuildContext context, int index) {
          return row(context, index);
        });
  }

  Widget row(BuildContext context, int index) {
    return Dismissible(
      key: Key(UniqueKey().toString()),
      onDismissed: (direction) {
        var workout = workouts[index];
        showDeleted(context, workout, index);
        removeWorkout(index);
      },
      background: refreshBackground(),
      child: Card(
        child: ListTile(
          title: Text(workouts[index]),
        ),
      ),
    );
  }

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WorkOutBuddy'),
      ),
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await refreshList();
          },
          child: list()),
    );
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    addAnyWorkout();
    return null;
  }

  addAnyWorkout() {
    int next = r.nextInt(100);
    setState(() {
      workouts.add("Workout $next");
    });
  }

  void removeWorkout(index) {
    setState(() {
      workouts.removeAt(index);
    });
  }

  void undoDelete(index, workout) {
    setState(() {
      workouts.insert(index, workout);
    });
  }

  void showDeleted(BuildContext context, workout, index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$workout deleted'),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          undoDelete(index, workout);
        },
      ),
    ));
  }

  static List workOutList() {
    List list = List.generate(len, (i) {
      return "Workout $i";
    });
    return list;
  }
}
