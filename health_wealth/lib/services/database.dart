import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/model/post.dart';
import 'package:health_wealth/model/postcard.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/model/runningdetails.dart';
import 'package:health_wealth/model/user.dart' as model;
import 'package:http/http.dart';

class DatabaseService {
  late final String uid = AuthService().currentUser.uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Collection reference for users.
  late final CollectionReference usersCollection = _db.collection('users');

  /// Collection reference for snacks.
  late final CollectionReference userSnacksCollection =
      _db.collection('users').doc(uid).collection('snacks');

  /// Collection reference for user workout routine.
  late final CollectionReference userWorkoutRoutineCollection =
      _db.collection('users').doc(uid).collection('workout routine');

  /// Collection reference for runs.
  late final CollectionReference runsCollection = _db.collection("runs");

  /// Collection reference for user followers
  late final CollectionReference followersCollection =
      _db.collection("followers");

  /// Collection reference for user followings
  late final CollectionReference followingsCollection =
      _db.collection("followings");

  /// Collection reference for user's posts
  late final CollectionReference postCollection = _db.collection("posts");

  /// Methods for User Settings.
  Future createUserDocument(String email) async {
    model.User user = model.User(
      username: email,
      uid: uid,
      email: email,
      followers: [],
      following: [],
    );
    return await usersCollection.doc(uid).set(user.toJson());
  }

  /// Method to retreive user data from database
  Future<model.User> getUserDetails() async {
    User currentUser = AuthService().currentUser;

    DocumentSnapshot snap =
        await _db.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
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
  /// This method can be extended if the Snack class is modelled differently.
  Future updateSnack(Snack snack) async {
    return await userSnacksCollection.doc(snack.name).update(snack.toJson());
  }

  /// Update snack name in the user's snack collection
  Future updateSnackName(Snack oldSnack, String name) async {
    await addSnack(Snack(name: name, calories: oldSnack.calories));
    await deleteSnack(oldSnack);
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
      return Snack(name: data['name'], calories: data['calories']);
    }).toList();
  }

  /// Methods for WorkoutBuddy
  /// Add exercise to the user's workout routine collection.
  Future addExercise(Exercise exercise) async {
    await userWorkoutRoutineCollection
        .doc(exercise.name)
        .set(exercise.toJson());
  }

  /// Update exercise in the user's workout routine collection.
  /// Exercise attributes are changed except for it's name.
  Future updateExercise(Exercise exercise) async {
    return await userWorkoutRoutineCollection
        .doc(exercise.name)
        .update(exercise.toJson());
  }

  /// Get Exercises stream
  Stream<List<Exercise>> get getExercises {
    return userWorkoutRoutineCollection
        .snapshots()
        .map(_snapshotToListOfExercises);
  }

  /// Get a List of Exercises from QuerySnapshot
  List<Exercise> _snapshotToListOfExercises(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Exercise.fromJson(data);
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

// For ShareIT
  Future followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await followingsCollection.doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      // unfollow function
      if (following.contains(followId)) {
        await followingsCollection.doc(followId).update({
          'following': FieldValue.arrayRemove([uid])
        });
        await followingsCollection.doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        // follow function
        await followingsCollection.doc(followId).update({
          'following': FieldValue.arrayUnion([uid])
        });

        await followingsCollection.doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<List<PostCard>> get getPosts {
    return postCollection
        .doc(uid)
        .collection('posts')
        .snapshots()
        .map(snapshotToListOfPosts);
  }

  List<PostCard> snapshotToListOfPosts(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return PostCard(
        snap: data['snap'],
      );
    }).toList();
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
