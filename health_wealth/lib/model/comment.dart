import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String comment;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;

  const Comment({
    required this.comment,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
  });

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      comment: snapshot["comment"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
    );
  }

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
      };
}
