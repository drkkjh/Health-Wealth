// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/shareit/discussion_comments_page.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DiscussionCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final String username;
  const DiscussionCard({
    Key? key,
    required this.snap,
    required this.username,
  }) : super(key: key);

  @override
  State<DiscussionCard> createState() => _PostCardState();
}

class _PostCardState extends State<DiscussionCard> {
  int commentLen = 0;
  final DatabaseService _db = DatabaseService();
  Methods methods = Methods();
  late DateFormat dateFormat;
  late DateFormat timeFormat;
  final User user = AuthService().currentUser;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = DateFormat.yMMMMd('en_SG');
    timeFormat = DateFormat.Hms('en_SG');
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await _db.discussionsCollection
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      print(err);
    }
    setState(() {});
  }

  deleteDiscussion(String postId) async {
    methods.deleteDiscussion(postId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'] == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shrinkWrap: true,
                                children: [
                                  'Delete discussion post',
                                ]
                                    .map(
                                      (e) => InkWell(
                                        onTap: () {
                                          deleteDiscussion(
                                            widget.snap['postId'].toString(),
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          //Description
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    child: Text(' ${widget.snap['description']}')),
              ),
            ],
          ),
          // Like & comment section
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DiscussionCommentsPage(
                        postId: widget.snap['postId'],
                        userName: widget.username,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DiscussionCommentsPage(
                    postId: widget.snap['postId'],
                    userName: widget.username,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
              ),
              child: const Text(
                'View all comments',
                // 'View all $commentLen comments',
                style: TextStyle(
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: Text(
              // MILESTONE 3: CONVERT DATE TIME HERE TO EN_SG time
              DateFormat.yMd()
                  .add_jm()
                  .format(widget.snap['datePublished'].toDate()),
              style: const TextStyle(
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
