// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_wealth/model/comment.dart';
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
    // TODO: Abstract away into a DatabaseService method
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
      // TODO: Abstract away into a DatabaseService method
      await _db.postsCollection.doc(postId).set(post.toJson());
      result = 'successfully added to database';
    } catch (err) {
      result = err.toString();
    }
    print(result); // used for debugging
  }

  void addFeedComment(
      String com, String uid, String username, String postId) async {
    // String result = 'debug';
    try {
      Comment comment = Comment(
        comment: com,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
      );
      await _db.postsCollection
          .doc(postId)
          .collection(postId)
          .doc(postId)
          .set(comment.toJson());
      // result = 'successfully added to database';
    } catch (err) {
      print(err.toString());
    }
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
      await _db.discussionsCollection.doc(postId).set(post.toJson());
      result = 'successfully added to database';
    } catch (err) {
      result = err.toString();
    }
    print(result); // used for debugging
  }

  Future<String> addDiscussionComment(
      String com, String uid, String username, String postId) async {
    String result = 'debug';
    try {
      String commentId = const Uuid().v1();
      Comment comment = Comment(
        comment: com,
        uid: uid,
        username: username,
        postId: commentId,
        datePublished: DateTime.now(),
      );
      await _db.discussionsCollection
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(comment.toJson());
      result = 'successfully added to database 123';
      return result;
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
  }

  Future<String> addPostComment(
      String com, String uid, String username, String postId) async {
    String result = 'debug';
    try {
      String commentId = const Uuid().v1();
      Comment comment = Comment(
        comment: com,
        uid: uid,
        username: username,
        postId: commentId,
        datePublished: DateTime.now(),
      );
      await _db.postsCollection
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(comment.toJson());
      result = 'successfully added to database 123';
      return result;
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
  }

  deletePost(String postId) async {
    try {
      // TODO: Abstract away into a DatabaseService method
      await _db.postsCollection.doc(postId).delete();
      print('successfully deleted post'); // for debugging
    } catch (e) {
      print(e.toString());
    }
  }

  deletePostComment(String postId, String commentId) async {
    await _db.postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  deleteDiscussion(String postId) async {
    try {
      // TODO: Abstract away into a DatabaseService method
      await _db.discussionsCollection.doc(postId).delete();
      print('successfully deleted post'); // for debugging
    } catch (e) {
      print(e.toString());
    }
  }

  deleteDiscussionComment(String postId, String commentId) async {
    await _db.discussionsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    // TODO: Abstract away into a DatabaseService method
    try {
      if (likes.contains(uid)) {
        // already liked the post
        await _db.postsCollection.doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        // havent like the post
        await _db.postsCollection.doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
