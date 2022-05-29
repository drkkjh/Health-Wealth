// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/authenticate/authenticate.dart';
import 'package:health_wealth/screens/feature_wrapper.dart';
import 'package:provider/provider.dart';

/// This class listens for changes in User sign-in state and renders either
/// the Authenticate widget or the FeatureWrapper widget.
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print('curr user uid: ${user?.uid}');

    if (user == null) {
      return const Authenticate();
    } else {
      return const FeatureWrapper();
    }
  }
}
