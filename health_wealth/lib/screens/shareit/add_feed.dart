// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/model/post.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/model/user.dart' as model;
import 'package:health_wealth/services/database.dart';
import 'package:uuid/uuid.dart';

class AddToFeed extends StatefulWidget {
  const AddToFeed({Key? key}) : super(key: key);

  @override
  State<AddToFeed> createState() => _AddToFeedState();
}

class _AddToFeedState extends State<AddToFeed> {
  // User inputs description for Post
  final _db = DatabaseService();
  User user = AuthService().currentUser;
  late String _userName;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    var snapshot =
        _db.usersCollection.doc(user.uid).snapshots() as Map<String, dynamic>;
    _userName = snapshot["username"];
  }

  void _addFeed(String description, String uid, String username) async {
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
      _db.postCollection.doc(postId).set(post.toJson());
      result = 'successfully added to database';
    } catch (err) {
      result = err.toString();
    }
    print(result); // used for debugging
  }

  void undo() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<model.User>(
        stream: _db.getUserDetails,
        builder: (context, AsyncSnapshot<model.User> snapshot) {
          if (snapshot.hasData) {
            var snap = snapshot.data;
            _userName = snap!.username;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text('Posting to Feed'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: undo,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _addFeed(_descriptionController.text, user.uid, _userName);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Post to feed',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption for your post',
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
