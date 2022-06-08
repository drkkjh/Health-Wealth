import 'package:flutter/material.dart';
import 'package:health_wealth/screens/runtracker.dart';
import 'package:health_wealth/screens/settings.dart';
import 'package:health_wealth/screens/shareit.dart';
import 'package:health_wealth/screens/snacktracker.dart';
import 'package:health_wealth/screens/workoutbuddy.dart';
import 'package:health_wealth/services/auth.dart';

/// The FeatureWrapper widget handles the navigation between the four feature
/// screens.

class FeatureWrapper extends StatefulWidget {
  const FeatureWrapper({Key? key}) : super(key: key);

  @override
  State<FeatureWrapper> createState() => _FeatureWrapperState();
}

class _FeatureWrapperState extends State<FeatureWrapper> {
  final AuthService _auth = AuthService();
  int currentIndex = 0;

  final screens = [
    const SnackTracker(),
    const WorkOutBuddy(workout: 'Workout 1'),
    const RunTracker(),
    const ShareIt(),
    const Settings()
  ];

  @override
  Widget build(BuildContext context) {
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
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlue,
        selectedItemColor: Colors.white,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
      ),
    );
  }
}
