// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create customUser obj base on Firebases' User obj
  // CustomUser? _fbUserToCustomUser(User? user) {
  //   return user != null ? CustomUser(uid: user.uid) : null;
  // }

  // auth change user stream
  // Stream<CustomUser?> get getUser {
  //   return _auth.authStateChanges().map(_fbUserToCustomUser);
  // }
  Stream<User?> get getUser {
    return _auth.authStateChanges();
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      print('$user has signed in anonymously');
      return user;
      // return _fbUserToCustomUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password

  // register in with email & password

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
