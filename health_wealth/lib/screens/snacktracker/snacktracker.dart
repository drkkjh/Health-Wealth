import 'package:flutter/material.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/screens/snacktracker/snack_list.dart';
import 'package:health_wealth/services/database.dart';
import 'package:provider/provider.dart';

class SnackTracker extends StatefulWidget {
  const SnackTracker({Key? key}) : super(key: key);

  @override
  State<SnackTracker> createState() => _SnackTrackerState();
}

class _SnackTrackerState extends State<SnackTracker> {
  final DatabaseService _db = DatabaseService();

  Widget appBarTitle = const Text("SnackTracker");
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Snack>?>.value(
      initialData: const [],
      value: _db.getSnacks,
      // catchError: (_, err) => [Snack(name: 'test', calories: 2.0)],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: appBarTitle,
          backgroundColor: Colors.lightBlue,
          actions: <Widget>[
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
                        hintText: 'Search for snack',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    actionIcon = const Icon(Icons.search);
                    appBarTitle = const Text("SnackTracker");
                  }
                });
              },
            ),
          ],
        ),
        body: const SnackList(),
      ),
    );
  }
}
