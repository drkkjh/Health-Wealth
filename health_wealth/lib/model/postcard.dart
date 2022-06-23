import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/shareit/like_animation.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  final DatabaseService _db = DatabaseService();
  Methods methods = Methods();
  late DateFormat dateFormat;
  late DateFormat timeFormat;
  final User user = AuthService().currentUser;
  bool isLikeAnimating = false;

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
      QuerySnapshot snap = await _db.postCollection
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      print(err);
    }
    setState(() {});
  }

  deletePost(String postId) async {
    methods.deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
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
                            'Delete post',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    deletePost(
                                      widget.snap['postId'].toString(),
                                    );
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
                ),
              ],
            ),
          ),
          //Description
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                child: Text(' ${widget.snap['description']}'),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  child:
                      const Icon(Icons.favorite, color: Colors.red, size: 100),
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              ),
            ],
          ),
          // Like & comment section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () => methods.likePost(
                    widget.snap['postId'].toString(),
                    user.uid,
                    widget.snap['likes'],
                  ),
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {},
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text('${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyText2),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: const Text(
                'View all comments',
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
