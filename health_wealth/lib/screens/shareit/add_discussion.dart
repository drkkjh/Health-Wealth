import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:health_wealth/model/user.dart' as model;

class AddToDiscussion extends StatefulWidget {
  const AddToDiscussion({Key? key}) : super(key: key);

  @override
  State<AddToDiscussion> createState() => _AddToDiscussionState();
}

class _AddToDiscussionState extends State<AddToDiscussion> {
  // User inputs for discussion post
  final DatabaseService _db = DatabaseService();
  User user = AuthService().currentUser;
  final TextEditingController _descriptionController = TextEditingController();
  late String _userName;
  Methods methods = Methods();

  void _addDiscussion(String description, String uid, String username) async {
    methods.addDiscussion(description, uid, username);
  }

  void undo() {
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
                onPressed: undo,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    _addDiscussion(
                        _descriptionController.text, user.uid, _userName);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Post',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: SizedBox(
                    // width: MediaQuery.of(context).size.width ,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Post your query to discussion',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 8,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
