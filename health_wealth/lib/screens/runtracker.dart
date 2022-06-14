import 'package:flutter/material.dart';
import 'package:health_wealth/model/runlist.dart';
import 'package:health_wealth/screens/running.dart';
import 'package:provider/provider.dart';
import '../model/runningdetails.dart';
import '../services/auth.dart';
import '../services/database.dart';

class RunTracker extends StatefulWidget {
  const RunTracker({Key? key}) : super(key: key);

  @override
  State<RunTracker> createState() => _RunTrackerState();
}

class _RunTrackerState extends State<RunTracker> {
  late final _db = DatabaseService();
  final user = AuthService().currentUser;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return StreamProvider<List<RunningDetails>?>.value(
      initialData: const [],
      value: _db.getRuns,
      /*catchError: (_, err) => [
        RunningDetails(
            id: 'abc',
            date: '14/6/2022',
            duration: '20.0',
            speed: 1.0,
            distance: 2.4)
      ],*/
      child: Scaffold(
        appBar: AppBar(
          title: const Text("RunTracker"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: const RunList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () {
            final activityToTrack = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Running(),
              ),
            );
          },
          tooltip: 'Press to start tracking a run',
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
