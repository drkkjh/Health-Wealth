import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/screens/snacktracker/add_snack.dart';
import 'package:health_wealth/screens/snacktracker/search_nutrition.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Snack>?>.value(
      initialData: const [],
      value: _db.getSnacks,
      // catchError: (_, err) => [Snack(name: 'test', calories: 2.0)],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('SnackTracker'),
          backgroundColor: Colors.lightBlue,
        ),
        body: const SnackList(),
        floatingActionButton: SpeedDial(
          activeBackgroundColor: Colors.blueAccent,
          activeIcon: Icons.clear,
          icon: Icons.more_vert,
          children: [
            SpeedDialChild(
              label: 'Add snack',
              child: const Icon(Icons.add),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddSnack()),
                );
              },
            ),
            SpeedDialChild(
              label: 'Search for nutritional info',
              child: const Icon(Icons.search),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchNutrition()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
