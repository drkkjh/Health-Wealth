import 'package:flutter/material.dart';

class RunTracker extends StatefulWidget {
  const RunTracker({Key? key}) : super(key: key);

  @override
  State<RunTracker> createState() => _RunTrackerState();
}

class _RunTrackerState extends State<RunTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RunTracker'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: const Center(
        child: Text(
          'RunTracker page coming soon!',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }
}
