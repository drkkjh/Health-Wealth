import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:health_wealth/widgets/postcommentcard.dart';

class PostCommentsPage extends StatefulWidget {
  final String postId;
  final String userName;
  const PostCommentsPage(
      {required this.postId, required this.userName, Key? key})
      : super(key: key);

  @override
  State<PostCommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<PostCommentsPage> {
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();
  Methods methods = Methods();
  final TextEditingController commentController = TextEditingController();
  late String username;

  void postComment(String comment, String uid) async {
    try {
      await methods.addPostComment(
          comment, uid, widget.userName, widget.postId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment added successfully'),
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add comment'),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = widget.userName;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      // Comments page UI
      //body: StreamBuilder<QuerySnapshot> of commentcards
      body: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: _db.getPostCommentsSnapshot(widget.postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => PostCommentCard(
                snap: snapshot.data!.docs[index].data(),
                postId: widget.postId,
              ),
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
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as $username',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // post button
              InkWell(
                onTap: (() {
                  postComment(commentController.text, _auth.currentUser.uid);
                  FocusScope.of(context).unfocus();
                  commentController.clear();
                }),
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
