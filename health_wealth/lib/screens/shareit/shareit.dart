import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_wealth/widgets/discussion_card.dart';
import 'package:health_wealth/widgets/post_card.dart';
import 'package:health_wealth/model/user.dart';
import 'package:health_wealth/screens/shareit/add_discussion.dart';
import 'package:health_wealth/screens/shareit/add_feed.dart';
import 'package:health_wealth/screens/shareit/search_users.dart';
import 'package:health_wealth/services/database.dart';

class ShareIt extends StatefulWidget {
  const ShareIt({Key? key}) : super(key: key);

  @override
  State<ShareIt> createState() => _ShareItState();
}

class _ShareItState extends State<ShareIt> {
  int currentIndex = 3;
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ShareIt'),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          bottom: TabBar(
            indicatorColor: Colors.orange,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.orange, // Creates border
            ),
            tabs: const [
              Tab(text: 'Feed'),
              Tab(text: 'Discussion'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Scaffold(
              floatingActionButton: const CustomSpeedDial(),
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
                        following: [''],
                        totalKcal: 0,
                        kcalLimit: 0,
                      );
                  return StreamBuilder<QuerySnapshot>(
                    stream: _db.getPostsSnapshot(user),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => PostCard(
                              snap: snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>,
                              username: user.username),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Scaffold(
              floatingActionButton: const CustomSpeedDial(),
              body: StreamBuilder<User>(
                stream: _db.getUserDetails,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    User user = snapshot.data!;
                    return StreamBuilder<QuerySnapshot>(
                      stream: _db.getDiscussionsSnapshot,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => DiscussionCard(
                                snap: snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>,
                                username: user.username),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSpeedDial extends StatelessWidget {
  const CustomSpeedDial({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      activeBackgroundColor: Colors.blue[500],
      activeIcon: Icons.cancel,
      icon: Icons.more_vert,
      children: [
        SpeedDialChild(
          label: 'Add post to Discussion',
          child: const Icon(Icons.add_circle),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddToDiscussion()),
            );
          },
        ),
        SpeedDialChild(
          label: 'Add post to Feed',
          child: const Icon(Icons.add_circle),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddToFeed()),
            );
          },
        ),
        SpeedDialChild(
          label: 'Search for users',
          child: const Icon(Icons.person_search_outlined),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  // builder: (context) => const SearchScreen()),
                  builder: (context) => const SearchUsers()),
            );
          },
        ),
      ],
    );
  }
}
