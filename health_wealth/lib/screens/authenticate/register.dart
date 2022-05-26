// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:health_wealth/services/auth.dart';

/// The Register screen widget.
/// Users will be logged in upon successful registration and brought to the
/// Home screen.
class Register extends StatefulWidget {
  final Function togglePage;

  const Register({Key? key, required this.togglePage}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // User input variables
  String email = '';
  String password = '';

  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0.0,
        title: const Text('Register'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign in'),
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
                  if (input != null && input.length < 6) {
                    return 'Your password must be at least 6 characters!';
                  } else {
                    return null;
                  }
                },
                onChanged: (input) {
                  setState(() => password = input);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text(
                  'Create an account',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  // Check if form is valid.
                  if (_formKey.currentState != null) {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.register(email, password);
                      if (result == null) {
                        setState(() => errorMsg = 'Error with registration');
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                errorMsg,
                style: const TextStyle(
                  color: Colors.white,
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
