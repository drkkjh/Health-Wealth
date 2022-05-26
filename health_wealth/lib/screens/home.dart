import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // get screen width
    double height = MediaQuery.of(context).size.height; // get screen height
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Health==Wealth'),
      ),
      body: SafeArea(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: <Widget>[
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.plus_one),
                label: Text('snackTracker')),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.plus_one),
                label: Text('runTracker')),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.plus_one),
                label: Text('workoutBuddy')),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.plus_one),
                label: Text('shareIT')),
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
