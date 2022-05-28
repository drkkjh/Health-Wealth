import 'package:flutter/material.dart';
import 'package:health_wealth/services/auth.dart';

class ShareIt extends StatefulWidget {
  const ShareIt({Key? key}) : super(key: key);

  @override
  State<ShareIt> createState() => _ShareItState();
}

class _ShareItState extends State<ShareIt> {
  final AuthService _auth = AuthService();
  int currentIndex = 3;

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
                text: 'General',
              ),
              Tab(
                text: 'Discussion',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // TODO: Create General and Discussion screens
            Center(
              child: Text(
                'General page coming soon!',
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
