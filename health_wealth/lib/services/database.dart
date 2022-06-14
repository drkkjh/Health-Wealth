import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_wealth/model/runningcard.dart';
import 'package:health_wealth/model/runningdetails.dart';
import 'package:health_wealth/screens/running.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseService {
  final String uid;
  static late Database _db;
  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  // Collection reference for runs
  final CollectionReference runsCollection =
      FirebaseFirestore.instance.collection("runs");

  Future createUser(String email) async {
    return await usersCollection
        .doc(uid)
        .set({'username': email, 'email': email});
  }

  Future updateUsername(String username) async {
    // TODO: Implement logic to check that username isn't taken
    return await usersCollection.doc(uid).update({'username': username});
    // .set({'username': username}, SetOptions(merge: true));
  }

  // For RunTracker specifically
  Stream<List<RunningDetails>> get getRuns {
    return runsCollection.snapshots().map(_snapshotToListOfRuns);
  }

  List<RunningDetails> _snapshotToListOfRuns(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return RunningDetails(
        date: data['date'] ?? '',
        duration: data['duration'] ?? '',
        speed: data['speed'] ?? '',
        distance: data['distance'] ?? '',
      );
    }).toList();
  }

  Future insertRun(RunningDetails details) async {
    return await runsCollection.doc(uid).set({
      'date': details.date,
      'duration': details.duration,
      'speed': details.speed,
      'distance': details.duration,
    });
  }
}

/// Custom DatabaseServiceExceptions
class UsernameTakenException implements Exception {
  const UsernameTakenException() : super();

  /// Getter that returns error message.
  String get message {
    return 'Username is already taken.';
  }
}
