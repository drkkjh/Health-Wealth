import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/model/runningdetails.dart';

class DatabaseService {
  late final String uid = AuthService().currentUser.uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Collection reference for users.
  late final CollectionReference usersCollection = _db.collection('users');

  /// Collection reference for snacks.
  late final CollectionReference userSnacksCollection =
      _db.collection('users').doc(uid).collection('snacks');

  /// Collection reference for runs.
  late final CollectionReference runsCollection = _db.collection("runs");

  /// Methods for User Settings.
  Future createUserDocument(String email) async {
    return await usersCollection
        .doc(uid)
        .set({'username': email, 'email': email});
  }

  Future updateUsername(String username) async {
    // TODO: Implement logic to check that username isn't taken
    return await usersCollection.doc(uid).update({'username': username});
    // .set({'username': username}, SetOptions(merge: true));
  }

  /// Methods for SnackTracker.
  /// Add snack to the user's snacks collection.
  Future addSnack(Snack snack) async {
    await userSnacksCollection.doc(snack.name).set(snack.toJson());
  }

  /// Update snack in the user's snacks collection.
  Future updateSnackCalories(Snack snack) async {
    return await userSnacksCollection
        .doc(snack.name)
        .update({'calories': snack.calories});
  }

  /// Delete snack from the user's snacks collection.
  Future deleteSnack(Snack snack) async {
    return await userSnacksCollection.doc(snack.name).delete();
  }

  /// Get Snacks stream
  Stream<List<Snack>> get getSnacks {
    return userSnacksCollection
        .orderBy('calories', descending: true)
        .snapshots()
        .map(_snapshotToListOfSnacks);
  }

  /// Get a List of Snacks from QuerySnapshot
  List<Snack> _snapshotToListOfSnacks(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      // return Snack(name: data['name'], calories: data['calories']);
      return Snack(name: data['name'], calories: data['calories']);
    }).toList();
  }

  /// Methods for RunTracker
  Stream<List<RunningDetails>> get getRuns {
    return runsCollection
        .doc(uid)
        .collection('run data')
        .snapshots()
        .map(snapshotToListOfRuns);
  }

  List<RunningDetails> snapshotToListOfRuns(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return RunningDetails(
        id: data['id'],
        date: data['date'],
        duration: data['duration'],
        speed: data['speed'],
        distance: data['distance'],
      );
    }).toList();
  }

  Future insertRun(RunningDetails details) async {
    return await runsCollection.doc(uid).collection('run data').add({
      'id': details.id,
      'date': details.date,
      'duration': details.duration,
      'speed': details.speed,
      'distance': details.distance,
    });
  }
}

/// Custom DatabaseServiceExceptions.
class UsernameTakenException implements Exception {
  const UsernameTakenException() : super();

  /// Getter that returns error message.
  String get message {
    return 'Username is already taken.';
  }
}
