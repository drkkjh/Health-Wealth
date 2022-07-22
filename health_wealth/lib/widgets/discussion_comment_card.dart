import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:intl/intl.dart';

class DiscussionCommentCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final String postId;
  const DiscussionCommentCard(
      {required this.snap, required this.postId, Key? key})
      : super(key: key);

  @override
  State<DiscussionCommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<DiscussionCommentCard> {
  Methods methods = Methods();
  final User user = AuthService().currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['comment']}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.snap['uid'] == user.uid
              ? InkWell(
                  onTap: () async {
                    await methods
                        .deleteDiscussionComment(
                            widget.postId, widget.snap['postId'])
                        .whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Successfully deleted comment'),
                        ),
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.delete_forever,
                      size: 20.0,
                      color: Colors.red,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
