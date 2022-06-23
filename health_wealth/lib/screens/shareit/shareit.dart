import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_wealth/model/postcard.dart';
import 'package:health_wealth/screens/shareit/add_discussion.dart';
import 'package:health_wealth/screens/shareit/add_feed.dart';
import 'package:health_wealth/screens/shareit/search_users.dart';
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
              body: StreamProvider<List<PostCard>?>.value(
                initialData: const [],
                value: _db.getPosts,
                child: const Scaffold(
                  floatingActionButton: CustomSpeedDial(),
                ),
              ),
            ),
            const Scaffold(
              // TODO: Use StreamBuilder to render list of discussion posts
              floatingActionButton: CustomSpeedDial(),
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
