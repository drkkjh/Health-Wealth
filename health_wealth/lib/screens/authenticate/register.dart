// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/common/loading.dart';
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
  bool loading = false;

  // User input variables
  String email = '';
  String password = '';

  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    } else {
      return Scaffold(
        // backgroundColor: Colors.,
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          elevation: 0.0,
          title: const Text('Register'),
          actions: [
            TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
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
                  decoration: formInputDecoration.copyWith(hintText: 'Email'),
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
                  decoration:
                      formInputDecoration.copyWith(hintText: 'Password'),
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
                          setState(() => loading = true);
                          dynamic result = await _auth.signIn(email, password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              errorMsg = 'Error with registration';
                            });
                          }
                        }
                      }
                    }),
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
}
