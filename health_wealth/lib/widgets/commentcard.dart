import 'package:flutter/material.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:health_wealth/services/database.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({required this.snap, Key? key}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
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
                          text: '${widget.snap['description']}',
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
                      widget.snap['datePublished'],
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
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.favorite, size: 16.0),
          ),
        ],
      ),
    );
  }
}
