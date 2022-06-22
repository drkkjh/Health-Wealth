import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/model/post.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:uuid/uuid.dart';
import 'package:health_wealth/model/user.dart' as model;

class AddToDiscussion extends StatefulWidget {
  const AddToDiscussion({Key? key}) : super(key: key);

  @override
  State<AddToDiscussion> createState() => _AddToDiscussionState();
}

class _AddToDiscussionState extends State<AddToDiscussion> {
  // User inputs for discussion post
  DatabaseService _db = DatabaseService();
  User user = AuthService().currentUser;
  TextEditingController _descriptionController = TextEditingController();
  late String _userName;

  void _addDiscussion(String description, String uid, String username) async {
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
      _db.discussionCollection.doc(postId).set(post.toJson());
      result = 'successfully added to database';
    } catch (err) {
      result = err.toString();
    }
    print(result); // used for debugging
  }

  void Undo() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
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
              title: const Text('Posting to Discussion'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: Undo,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _addDiscussion(
                        _descriptionController.text, user.uid, _userName);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Post your query to discussion',
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
                      hintText: 'Post your query to discussion',
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
