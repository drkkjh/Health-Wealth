import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:health_wealth/widgets/commentcard.dart';
import 'package:health_wealth/model/user.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final DatabaseService _db = DatabaseService();
  //String username = _db.usersCollection.doc(user.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      // Comments page UI
      //body: StreamBuilder<QuerySnapshot> of commentcards
      body: Scaffold(
        body: StreamBuilder<User>(
          stream: _db.getUserDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            User user = snapshot.data ??
                const User(
                    username: '',
                    uid: '',
                    email: '',
                    followers: [''],
                    following: ['']);
            StreamBuilder<QuerySnapshot>(
              stream: _db.getPostsSnapshot(user),
              builder: (context, snapshot) {
                ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
                return StreamBuilder<DocumentSnapshot>(
                    stream: _db.getCommentsSnapshot(postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) => CommentCard(
                          snap: snapshot.data!.data(),
                        ),
                      );
                    });
              },
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: const InputDecoration(
                      hintText: 'Comment as username',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // post button
              InkWell(
                onTap: (() {}),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ), // show text field and post button
        ),
      ),
    );
  }
}
