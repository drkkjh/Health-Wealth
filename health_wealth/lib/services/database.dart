import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/auth.dart';

class DatabaseService {
  final _auth = AuthService();
  late final String uid = _auth.currentUser.uid;

  // final String uid;
  // DatabaseService({required this.uid});

  // Collection references
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  late final CollectionReference userSnacksCollection = FirebaseFirestore
      .instance
      .collection('users')
      .doc(uid)
      .collection('snacks');

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

  /// Add snack to the user's snacks collection.
  Future addSnack(Snack snack) async {
    await userSnacksCollection.doc(snack.name).set(snack.toJson());
  }

  /// Update snack in the user's snacks collection.
  // * Unnecessary?
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
}

/// Custom DatabaseServiceExceptions.
class UsernameTakenException implements Exception {
  const UsernameTakenException() : super();

  /// Getter that returns error message.
  String get message {
    return 'Username is already taken.';
  }
}
