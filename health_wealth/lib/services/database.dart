import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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
}

/// Custom DatabaseServiceExceptions
class UsernameTakenException implements Exception {
  const UsernameTakenException() : super();

  /// Getter that returns error message.
  String get message {
    return 'Username is already taken.';
  }
}
