// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_wealth/model/post.dart';
import 'package:health_wealth/model/user.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:uuid/uuid.dart';

class Methods {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  /// Returns true iff user if following the targetUser
  Future<bool> isFollowing(User targetUser) async {
    var snap = await _db.usersCollection.doc(_auth.currentUser.uid).get();
    User user = User.fromSnap(snap);
    return user.following.contains(targetUser.uid);
  }

  void addFeed(String description, String uid, String username) async {
    String result = 'For debugging purposes';
    try {
      String postId =
          const Uuid().v1(); // generating a unique postId based on current time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
      );
      await _db.postCollection.doc(postId).set(post.toJson());
      // * Add feed posts to top-level collection
      // TODO: Abstract away using a database method?
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(post.toJson());
      result = 'successfully added to database';
    } catch (err) {
      result = err.toString();
    }
    print(result); // used for debugging
  }

  void addDiscussion(String description, String uid, String username) async {
    String result = 'For debugging purposes';
    try {
      String postId =
          const Uuid().v1(); // generating a unique postId based on current time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
      );
      await _db.discussionCollection.doc(postId).set(post.toJson());
      // * Add discussion posts to top-level collection
      // TODO: Abstract away using a database method?
      await FirebaseFirestore.instance
          .collection('discussions')
          .doc(postId)
          .set(post.toJson());
      result = 'successfully added to database';
    } catch (err) {
      result = err.toString();
    }
    print(result); // used for debugging
  }

  deletePost(String postId) async {
    try {
      await _db.postCollection.doc(postId).delete();
      print('successfully deleted post'); // for debugging
    } catch (e) {
      print(e.toString());
    }
  }
}
