import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_wealth/model/discussioncard.dart';
import 'package:health_wealth/model/post.dart';
import 'package:health_wealth/model/postcard.dart';
import 'package:health_wealth/screens/shareit/add_discussion.dart';
import 'package:health_wealth/screens/shareit/add_feed.dart';
import 'package:health_wealth/screens/shareit/search_screen.dart';
import 'package:health_wealth/services/database.dart';
import 'package:provider/provider.dart';

class ShareIt extends StatefulWidget {
  const ShareIt({Key? key}) : super(key: key);

  @override
  State<ShareIt> createState() => _ShareItState();
}

class _ShareItState extends State<ShareIt> {
  int currentIndex = 3;
  final DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

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
              Tab(
                text: 'Feed',
              ),
              Tab(
                text: 'Discussion',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TODO: Create Feed and Discussion screens
            Scaffold(
              floatingActionButton: SpeedDial(
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
                          MaterialPageRoute(
                              builder: (context) => const AddToDiscussion()),
                        );
                      },
                    ),
                    SpeedDialChild(
                      label: 'Add post to Feed',
                      child: const Icon(Icons.add_circle),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddToFeed()),
                        );
                      },
                    ),
                    SpeedDialChild(
                        label: 'Search for user',
                        child: const Icon(Icons.search),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchScreen()),
                          );
                        }),
                  ]),
              body: StreamBuilder(
                stream: _db.postCollection.snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  );
                },
              ),
            ),
            /*Scaffold(
              body: StreamProvider<List<PostCard>?>.value(
                initialData: const [],
                value: _db.getPosts,
                child: Scaffold(
                  floatingActionButton: SpeedDial(
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddToDiscussion()),
                            );
                          },
                        ),
                        SpeedDialChild(
                          label: 'Add post to Feed',
                          child: const Icon(Icons.add_circle),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddToFeed()),
                            );
                          },
                        ),
                      ]),
                ),
              ),
            ),*/
            /*Center(
              child: Text(
                'Feed coming soon!',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),*/
            Scaffold(
              floatingActionButton: SpeedDial(
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
                          MaterialPageRoute(
                              builder: (context) => const AddToDiscussion()),
                        );
                      },
                    ),
                    SpeedDialChild(
                      label: 'Add post to Feed',
                      child: const Icon(Icons.add_circle),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddToFeed()),
                        );
                      },
                    ),
                    SpeedDialChild(
                        label: 'Search for user',
                        child: const Icon(Icons.search),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchScreen()),
                          );
                        }),
                  ]),
              body: StreamBuilder(
                stream: _db.discussionCollection.snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => DiscussionCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
