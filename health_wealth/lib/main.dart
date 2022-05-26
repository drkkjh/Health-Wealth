import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().getUser,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
    // return const MaterialApp(
    //   home: Wrapper(),
    // );
  }
}
