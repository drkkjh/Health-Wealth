import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/model/post.dart';
import 'package:health_wealth/model/postcard.dart';
import 'package:health_wealth/providers/user_provider.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/model/user.dart' as model;
import 'package:health_wealth/services/database.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddToFeed extends StatefulWidget {
  const AddToFeed({Key? key}) : super(key: key);

  @override
  State<AddToFeed> createState() => _AddToFeedState();
}

class _AddToFeedState extends State<AddToFeed> {
  // User inputs description for PostCard
  String description = '';
  final _db = DatabaseService();
  final TextEditingController _descriptionController = TextEditingController();

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
        title: Text('Posting to Feed'),
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
                hintText: 'Write a caption',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
