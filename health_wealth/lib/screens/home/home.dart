// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:health_wealth/services/auth.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        title: const Text('Health== Wealth'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
    // return Container(
    //   child: const Text('home'),
    // );
  }
}
