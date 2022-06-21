import 'package:flutter/material.dart';
import 'package:health_wealth/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ShareIt extends StatefulWidget {
  const ShareIt({Key? key}) : super(key: key);

  @override
  State<ShareIt> createState() => _ShareItState();
}

class _ShareItState extends State<ShareIt> {
  int currentIndex = 3;

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
        body: const TabBarView(
          children: [
            // TODO: Create Feed and Discussion screens
            Center(
              child: Text(
                'Feed coming soon!',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
            Center(
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
