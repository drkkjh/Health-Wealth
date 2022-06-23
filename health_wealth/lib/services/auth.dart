// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

/// This class handles User Authentication functions.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create model.User object from a Firebases User obj
  // model.User? _fbUserToModelUser(User? user) {
  //   model.User user = _db.getUserDetails();
  //   return user;
  // return user != null
  //     ? model.User(
  //         username: user.email,
  //         uid: user.uid,
  //         email: user.email,
  //         followers: [],
  //         following: [],
  //       )
  //     : null;
  // }

  // Getter that returns User sign-in state in a Stream.
  // Stream<model.User?> get getUser {
  //   return _auth.authStateChanges().map(_fbUserToModelUser);
  // }

  /// Getter that returns current user.
  User get currentUser {
    return _auth.currentUser!;
  }

  /// Getter that returns User sign-in state in a Stream.
  Stream<User?> get getUser {
    return _auth.authStateChanges();
  }

  /// Sign in with email and password.
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print('$user has signed in');
      return user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  /// Register with email and password.
  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print('$user has registered');
      return user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  /// Sign out.
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
