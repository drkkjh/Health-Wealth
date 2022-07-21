// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

/// This class handles User Authentication functions.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  /// Change password
  Future changePassword(String oldPassword, String newPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!, password: oldPassword);
      await _auth.currentUser!.reauthenticateWithCredential(credential);
      await _auth.currentUser!.updatePassword(newPassword);
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
