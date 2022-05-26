// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/authenticate/authenticate.dart';
import 'package:health_wealth/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print('curr user uid: ${user?.uid}');

    if (user == null) {
      return const Authenticate();
    } else {
      return Home();
    }
  }
}
