import 'package:flutter/material.dart';
import 'package:health_wealth/model/runningdetails.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:health_wealth/widgets/runlist.dart';
import 'package:health_wealth/screens/runtracker/running.dart';
import 'package:provider/provider.dart';

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
    return StreamProvider<List<RunningDetails>?>.value(
      initialData: const [],
      value: _db.getRuns,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("RunTracker"),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("assets/RunTracker_background.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: const RunList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Running()),
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
