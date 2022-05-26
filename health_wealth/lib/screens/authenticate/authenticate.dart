// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:health_wealth/screens/authenticate/register.dart';
import 'package:health_wealth/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignInPage = true;

  // Function that toggles between SignIn and Register screens
  void togglePage() {
    setState(() => showSignInPage = !showSignInPage);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage) {
      return SignIn(togglePage: togglePage);
    } else {
      return Register(togglePage: togglePage);
    }
  }
}
