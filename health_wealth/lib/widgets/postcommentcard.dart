import 'package:flutter/material.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:health_wealth/services/database.dart';
import 'package:intl/intl.dart';

class PostCommentCard extends StatefulWidget {
  final snap;
  final String postId;
  const PostCommentCard({required this.snap, required this.postId, Key? key})
      : super(key: key);

  @override
  State<PostCommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<PostCommentCard> {
  final DatabaseService _db = DatabaseService();
  Methods methods = Methods();

  @override
  Widget build(BuildContext context) {
    // implement widget for a single comment
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
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              methods.deletePostComment(widget.postId, widget.snap['postId']);
              /*ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Successfully deleted comment'),
                ),
              );*/
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.delete_forever, size: 20.0, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
