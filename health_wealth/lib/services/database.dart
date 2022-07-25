// ignore_for_file: avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/model/running_details.dart';
import 'package:health_wealth/model/user.dart' as model;

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
  late final CollectionReference userRunsCollection =
      usersCollection.doc(uid).collection('runs');

  /// Collection reference for feed posts
  late final CollectionReference postsCollection = _db.collection('posts');

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
<<<<<<< HEAD
    // TODO: Implement logic to check that username isn't taken
    var data = usersCollection.where('username', isEqualTo: username).get();
    if (data != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar: SnackBar(content: Text('Username is taken'),),);
      break;
    } 
=======
    if (await findUsersByUsername(username) != null) {
      throw const UsernameTakenException();
    }
>>>>>>> main
    await usersCollection.doc(uid).update({'username': username});
    await updateUsernameInShareItPosts(username);
    return await updateUsernameInShareItComments(username);
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

  /// Delete all snacks from the user's snacks collection.
  Future deleteAllSnacks() async {
    var snapshots = await userSnacksCollection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    await usersCollection.doc(uid).update({'totalKcal': 0});
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

  Future changeExerciseIcon(Exercise exercise, int icon) async {
    await userWorkoutRoutineCollection
        .doc(exercise.name)
        .update({'iconIndex': icon});
  }

  /// Update exercise in the user's workout routine collection.
  /// Exercise attributes are changed except for it's name.
  Future updateExercise(Exercise exercise) async {
    return await userWorkoutRoutineCollection
        .doc(exercise.name)
        .update(exercise.toJson());
  }

  /// Delete exercise to the user's workout routine collection.
  Future deleteExercise(Exercise exercise) async {
    await userWorkoutRoutineCollection.doc(exercise.name).delete();
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
    return userRunsCollection
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map(snapshotToListOfRuns);
  }

  List<RunningDetails> snapshotToListOfRuns(QuerySnapshot snapshot) {
    return snapshot.docs.map((snap) => RunningDetails.fromSnap(snap)).toList();
  }

  Future insertRun(RunningDetails details) async {
    return await userRunsCollection.add({
      'id': details.id,
      'date': details.date,
      'duration': details.duration,
      'speed': details.speed,
      'distance': details.distance,
      'dateTime': details.dateTime,
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

  Future followUser(String followId) async {
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
    return postsCollection
        .where('uid', whereIn: listOfFollowing)
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  // Stream<Post> getPostDetails(String postId) {
  //   return postsCollection.doc(postId).snapshots().map(Post.fromSnap);
  // }

  Stream<QuerySnapshot> get getDiscussionsSnapshot {
    return discussionsCollection
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getDiscussionCommentsSnapshot(String postId) {
    return discussionsCollection
        .doc(postId)
        .collection('comments')
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostCommentsSnapshot(String postId) {
    return postsCollection
        .doc(postId)
        .collection('comments')
        .orderBy('datePublished', descending: true)
        .snapshots();
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

  Future<void> updateUsernameInShareItComments(String newName) async {
    QuerySnapshot q1 = await postsCollection.get();
    for (QueryDocumentSnapshot snap in q1.docs) {
      var data = snap.data() as Map<String, dynamic>;
      QuerySnapshot qq = await postsCollection
          .doc(data['postId'])
          .collection('comments')
          .where('uid', isEqualTo: uid)
          .get();
      for (QueryDocumentSnapshot sn in qq.docs) {
        var data2 = sn.data() as Map<String, dynamic>;
        await postsCollection
            .doc(data['postId'])
            .collection('comments')
            .doc(data2['postId'])
            .update({'username': newName});
      }
    }
    QuerySnapshot q2 = await discussionsCollection.get();
    for (QueryDocumentSnapshot snap in q2.docs) {
      var data = snap.data() as Map<String, dynamic>;
      QuerySnapshot qq = await discussionsCollection
          .doc(data['postId'])
          .collection('comments')
          .where('uid', isEqualTo: uid)
          .get();
      for (QueryDocumentSnapshot sn in qq.docs) {
        var data2 = sn.data() as Map<String, dynamic>;
        await discussionsCollection
            .doc(data['postId'])
            .collection('comments')
            .doc(data2['postId'])
            .update({'username': newName});
      }
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
