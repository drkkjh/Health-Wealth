import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final List followers;
  final List following;
  final num totalKcal;
  final num kcalLimit;

  const User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.followers,
      required this.following,
      required this.totalKcal,
      required this.kcalLimit});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      totalKcal: snapshot["totalKcal"],
      kcalLimit: snapshot["kcalLimit"],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "username": username,
        "followers": followers,
        "following": following,
        "totalKcal": totalKcal,
        "kcalLimit": kcalLimit,
      };
}
