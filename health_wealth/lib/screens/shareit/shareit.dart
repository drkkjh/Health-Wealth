import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_wealth/model/postcard.dart';
import 'package:health_wealth/providers/user_provider.dart';
import 'package:health_wealth/screens/shareit/add_discussion.dart';
import 'package:health_wealth/screens/shareit/add_feed.dart';
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
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
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
            ),
            /*Center(
              child: Text(
                'Feed coming soon!',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),*/
            const Center(
              child: Text(
                'Discussion page coming soon!',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}