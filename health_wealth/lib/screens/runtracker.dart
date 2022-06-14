import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/model/runlist.dart';
import 'package:health_wealth/screens/running.dart';
import 'package:health_wealth/model/runningcard.dart';
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
  late List<RunningDetails> _data;
  late List<RunningCard> _cards;
  final _auth = AuthService();
  late final _db = DatabaseService(uid: _auth.currentUser.uid);
  final user = AuthService().currentUser;

  void initState() {
    super.initState();
    _fetchDBEntries();
  }

  void _fetchDBEntries() async {
    _cards = []; // clear database
    //_data = _results.map((item) => RunningDetails.fromMap(item)).toList();
    //_data.forEach((value) => _cards.add(RunningCard(runningdetails: value)));
    setState(() {
      Stream<List<RunningDetails>> _results = _db.getRuns;
    });
  }

  void _addDBEntry(RunningDetails rd) async {
    _db.insertRun(rd);
    _fetchDBEntries();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: StreamProvider<List<RunningDetails>>.value(
        initialData: const [],
        value: _db.getRuns,
        child: Scaffold(
          appBar: AppBar(
            title: Text("RunTracker"),
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
                  builder: (context) => Running(),
                ),
              ).then((value) => _addDBEntry(value));
              setState() {}
            },
            tooltip: 'Press to start tracking a run',
            child: Icon(
              Icons.add,
            ),
          ),
        ),
      ),
    );
  }
}
