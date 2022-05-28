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

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              icon: const Icon(Icons.person),
              label: const Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
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
          title: const Text('ShareIt'),
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: ((index) => setState(() => currentIndex = index)),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'SnackTracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.man_sharp),
              label: 'WorkoutBuddy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.man_rounded),
              label: 'RunTracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'ShareIt',
            ),
          ],
        ),
      ),
    );
  }
}
