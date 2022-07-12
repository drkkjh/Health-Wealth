import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/screens/snacktracker/add_snack.dart';
import 'package:health_wealth/screens/snacktracker/search_nutrition.dart';
import 'package:health_wealth/screens/snacktracker/update_cal_limit_panel.dart';
import 'package:health_wealth/services/database.dart';
import 'package:health_wealth/widgets/snack_list.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class SnackTracker extends StatefulWidget {
  const SnackTracker({Key? key}) : super(key: key);

  @override
  State<SnackTracker> createState() => _SnackTrackerState();
}

class _SnackTrackerState extends State<SnackTracker> {
  final DatabaseService _db = DatabaseService();
  double totalKcal = 750;
  double kcalLimit = 1000;
  late double percent = totalKcal <= kcalLimit ? totalKcal / kcalLimit : 1;

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
        body: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            const Text(
              'Daily consumption',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: GestureDetector(
                onTap: _showChangeCalLimitPanel,
                child: LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1500,
                  percent: percent,
                  progressColor: percent <= 0.3
                      ? Colors.amber
                      : percent <= 0.7
                          ? Colors.orange
                          : Colors.red,
                  lineHeight: 25,
                  barRadius: const Radius.circular(20),
                  backgroundColor: Colors.white24,
                  center: Text(
                    '$totalKcal / $kcalLimit kcal',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 10),
            const SnackList(),
          ],
        ),
        // ),
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

  void _showChangeCalLimitPanel() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const UpdateCalLimitPanel(),
          );
        });
  }
}
