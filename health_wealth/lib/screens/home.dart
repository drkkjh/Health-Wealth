import 'package:flutter/material.dart';
import 'package:health_wealth/services/auth.dart';

// void main() {
//   runApp(MaterialApp(home: Home()));
// }

/// The Home screen widget.
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // get screen width
    double height = MediaQuery.of(context).size.height; // get screen height
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Health==Wealth'),
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
      ),
      body: SafeArea(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: <Widget>[
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.plus_one),
                label: const Text('snackTracker')),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.plus_one),
                label: const Text('runTracker')),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.plus_one),
                label: const Text('workoutBuddy')),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.plus_one),
                label: const Text('shareIT')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'abc',
          )
        ],
      ),
    );
  }
}
