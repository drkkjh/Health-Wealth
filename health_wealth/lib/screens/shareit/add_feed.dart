// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/model/user.dart' as model;
import 'package:health_wealth/services/database.dart';

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
  Methods methods = Methods();

  void _addFeed(String description, String uid, String username) async {
    methods.addFeed(description, uid, username);
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
                  child: TextField(
                    autofocus: true,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption for your post',
                      border: OutlineInputBorder(),
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
