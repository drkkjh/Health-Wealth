import 'package:flutter/material.dart';
import 'package:health_wealth/model/user.dart';
import 'package:health_wealth/widgets/follow_button.dart';
import 'package:health_wealth/screens/shareit/methods.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';

class SearchUserCard extends StatefulWidget {
  final User user;
  const SearchUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<SearchUserCard> createState() => _SearchUserCardState();
}

class _SearchUserCardState extends State<SearchUserCard> {
  final Methods methods = Methods();
  final _db = DatabaseService();

  bool? isFollowing;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: methods.isFollowing(widget.user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          isFollowing = snapshot.data as bool;
          return Card(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(width: 5),
                const Padding(
                  padding: EdgeInsets.only(left: 1),
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 400,
                    child: Text(
                      widget.user.username,
                      style: const TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FollowButton(
                    isFollowing: isFollowing!,
                    function: () async {
                      await _db.followUser(
                          AuthService().currentUser.uid, widget.user.uid);
                      setState(() => isFollowing = !isFollowing!);
                    },
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(child: Text('Error'));
        }
      },
    );
  }
}
