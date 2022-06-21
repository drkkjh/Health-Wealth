import 'package:flutter/material.dart';
import 'package:health_wealth/model/post.dart';
import 'package:health_wealth/providers/user_provider.dart';
import 'package:health_wealth/services/database.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddToDiscussion extends StatefulWidget {
  const AddToDiscussion({Key? key}) : super(key: key);

  @override
  State<AddToDiscussion> createState() => _AddToDiscussionState();
}

class _AddToDiscussionState extends State<AddToDiscussion> {
  // User inputs for discussion post
  String description = '';
  DatabaseService _db = DatabaseService();
  TextEditingController _descriptionController = TextEditingController();

  void AddDiscussion(String description, String uid, String username) async {
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
    setState(() {
      description = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Posting to Discussion'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Undo,
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Your question to be posted on Discussion',
                border: InputBorder.none,
              ),
              maxLines: 8,
            ),
          ),
        ],
      ),
    );
  }
}
