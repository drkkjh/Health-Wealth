// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:health_wealth/services/auth.dart';

class Register extends StatefulWidget {
  final Function togglePage;

  const Register({Key? key, required this.togglePage}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

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
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                onChanged: (input) {
                  setState(() => email = input);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
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
                  print(email);
                  print(password);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
