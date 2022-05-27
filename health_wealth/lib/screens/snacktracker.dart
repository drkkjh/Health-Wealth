import 'package:flutter/material.dart';

class SnackTracker extends StatefulWidget {
  const SnackTracker({Key? key}) : super(key: key);

  @override
  State<SnackTracker> createState() => _SnackTrackerState();
}

class _SnackTrackerState extends State<SnackTracker> {
  Widget appBarTitle = const Text("SnackTracker");
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (actionIcon.icon == Icons.search) {
                actionIcon = const Icon(Icons.close);
                appBarTitle = const TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.white)),
                );
              } else {
                actionIcon = const Icon(Icons.search);
                appBarTitle = const Text("SnackTracker");
              }
            });
          },
        ),
      ]),
    );
  }
}
