// ignore_for_file: avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/widgets/postcard.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/model/runningdetails.dart';
import 'package:health_wealth/model/user.dart' as model;

class DatabaseService {
  late final String uid = AuthService().currentUser.uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final String userName;

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

  /// Collection reference for feed posts
  late final CollectionReference postsCollection = _db.collection('posts');

  /// Subcollection reference for user's feed posts
  late final CollectionReference postsSubcollection =
      _db.collection('users').doc(uid).collection('posts');

  /// Collection reference for discussion posts
  late final CollectionReference discussionsCollection =
      _db.collection('discussions');

  Future createUserDocument(String email) async {
    model.User user = model.User(
      username: email,
      uid: uid,
      email: email,
      followers: [],
      following: [],
      totalKcal: 0,
      kcalLimit: 500,
    );
    return await usersCollection.doc(uid).set(user.toJson());
  }

  /// Method to retreive user data from database
  Stream<model.User> get getUserDetails {
    return usersCollection.doc(uid).snapshots().map(model.User.fromSnap);
  }

  Future updateUsername(String username) async {
    // TODO: Implement logic to check that username isn't taken
    await usersCollection.doc(uid).update({'username': username});
    return await updateUsernameInShareItPosts(username);
  }

  /// Methods for SnackTracker.
  /// Add snack to the user's snacks collection.
  Future addSnack(Snack snack) async {
    await userSnacksCollection.doc(snack.name).set(snack.toJson());
    await usersCollection
        .doc(uid)
        .update({'totalKcal': FieldValue.increment(snack.calories)});
  }

  /// Update snack in the user's snacks collection.
  /// This method can be extended if the Snack class is modelled differently.
  Future updateSnack(Snack snack, num calChange) async {
    await userSnacksCollection.doc(snack.name).update(snack.toJson());
    await usersCollection
        .doc(uid)
        .update({'totalKcal': FieldValue.increment(calChange)});
  }

  /// Update snack name in the user's snack collection
  Future updateSnackName(Snack oldSnack, String name) async {
    await addSnack(Snack(name: name, calories: oldSnack.calories));
    await deleteSnack(oldSnack);
  }

  /// Delete snack from the user's snacks collection.
  Future deleteSnack(Snack snack) async {
    await userSnacksCollection.doc(snack.name).delete();
    await usersCollection
        .doc(uid)
        .update({'totalKcal': FieldValue.increment(-snack.calories)});
  }

  /// Update user's caloric limit
  Future updateCalLimit(num limit) async {
    return await usersCollection.doc(uid).update({'kcalLimit': limit});
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

  /// For ShareIT

  /// Returns list of model.Users who the logged-in user follows.
  // Future<List<Future<model.User?>>> get getListOfFollowingUids async {
  //   DocumentSnapshot snap = await usersCollection.doc(uid).get();
  //   model.User user = model.User.fromSnap(snap);
  //   List<String> listFollowers = user.following;
  //   return listFollowers.map(_uidToModelUser).toList();
  // }

  /// Returns a model.User object given a uid.
  // Future<model.User?> _uidToModelUser(String uid) async {
  //   DocumentSnapshot snap = await usersCollection.doc(uid).get();
  //   return model.User.fromSnap(snap);
  // }

  /// Returns a model.User object with given username iff such a User exists.
  // * Might have to modify to return a List<model.User> if search criteria is changed
  // * (ie. Find all users where input string is a substring of user's username)
  Future<model.User?> findUsersByUsername(String username) async {
    QuerySnapshot snap =
        await usersCollection.where('username', isEqualTo: username).get();
    if (snap.size == 0) {
      return null;
    }
    // snap.docs must be size 1 assuming username is unique.
    model.User returnedUser = model.User.fromSnap(snap.docs[0]);
    // Ensures that logged-in users cannot find themselves in SearchUsers
    return returnedUser.uid != uid ? returnedUser : null;
  }

  Future followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await usersCollection.doc(uid).get();
      model.User user = model.User.fromSnap(snap);
      if (user.following.contains(followId)) {
        await usersCollection.doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await usersCollection.doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await usersCollection.doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await usersCollection.doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getPostsSnapshot(model.User user) {
    //  To ensure that firebase query has a non-empty list argument
    List listOfFollowing = user.following.isEmpty ? [''] : user.following;
    return postsCollection.where('uid', whereIn: listOfFollowing).snapshots();
  }

  Stream<DocumentSnapshot> getCommentsSnapshot(String pId) {
    return postsCollection.doc(pId).snapshots();
  }

  // * Not in use
  Stream<List<PostCard>> get getPosts {
    return postsCollection.snapshots().map(_snapshotToListOfPostCards);
  }

  List<PostCard> _snapshotToListOfPostCards(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return PostCard(
        snap: data['snap'],
      );
    }).toList();
  }

  Future<void> updateUsernameInShareItPosts(String newName) async {
    QuerySnapshot q1 = await postsCollection.where('uid', isEqualTo: uid).get();
    for (QueryDocumentSnapshot snap in q1.docs) {
      var data = snap.data() as Map<String, dynamic>;
      await postsCollection.doc(data['postId']).update({'username': newName});
    }
    QuerySnapshot q2 =
        await discussionsCollection.where('uid', isEqualTo: uid).get();
    for (QueryDocumentSnapshot snap in q2.docs) {
      var data = snap.data() as Map<String, dynamic>;
      await discussionsCollection
          .doc(data['postId'])
          .update({'username': newName});
    }
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
