import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/common/input_validator.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/widgets/loading.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // User input variables
  String email = '';
  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        autofocus: true,
                        decoration: formInputDecoration.copyWith(
                            hintText: 'Enter your email'),
                        validator: InputValidator.validateEmail,
                        onChanged: (input) {
                          setState(() => email = input);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        child: const Text(
                          'Send password reset link',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          // Check if form is valid.
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                              errorMsg = '';
                            });
                            try {
                              await _auth.resetPassword(email);
                              setState(() {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Password reset email has been sent'),
                                  ),
                                );
                              });
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                errorMsg = e.message!;
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        errorMsg,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
