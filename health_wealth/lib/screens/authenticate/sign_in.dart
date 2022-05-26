// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:health_wealth/services/auth.dart';

/// The Sign In screen widget.
/// Users will be brought to the Home screen upon successful sign in.
class SignIn extends StatefulWidget {
  final Function togglePage;

  const SignIn({Key? key, required this.togglePage}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // User input variables
  String email = '';
  String password = '';

  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        elevation: 0.0,
        title: const Text('Sign in'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Create account'),
            onPressed: () {
              widget.togglePage();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (input) {
                  if (input != null && input.isEmpty) {
                    return 'Enter your email';
                  } else {
                    return null;
                  }
                },
                onChanged: (input) {
                  setState(() => email = input);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                validator: (input) {
                  if (input != null) {
                    if (input.isEmpty) {
                      return 'Enter your password';
                    } else if (input.length < 6) {
                      return 'Your password must be at least 6 characters!';
                    }
                  }
                  return null;
                },
                onChanged: (input) {
                  setState(() => password = input);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  // Check if form is valid.
                  if (_formKey.currentState != null) {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.signIn(email, password);
                      if (result == null) {
                        setState(() => errorMsg = 'Error with signing in');
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                errorMsg,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
