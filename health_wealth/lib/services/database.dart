import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('user data');

  // Future updateUserData(String username) async {
  //   return await userDataCollection.startAtDocument(uid).set;
  // }

  Future<DocumentReference> addUsername(String username) async {
    return await userDataCollection.add(username);
  }
}
