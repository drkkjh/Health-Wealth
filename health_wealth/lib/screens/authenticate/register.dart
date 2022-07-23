import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/screens/authenticate/email_validator.dart';
import 'package:health_wealth/screens/authenticate/password_validator.dart';
import 'package:health_wealth/widgets/loading.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';

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
  final DatabaseService _db = DatabaseService();
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
        appBar: AppBar(
          backgroundColor: Colors.blue,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              formInputDecoration.copyWith(hintText: 'Email'),
                          validator: EmailValidator.validate,
                          onChanged: (input) {
                            setState(() => email = input);
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          obscureText: true,
                          decoration: formInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: PasswordValidator.validate,
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
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              try {
                                User user =
                                    await _auth.register(email, password);
                                await _db.createUserDocument(email);
                                await _db.followUser(user.uid);
                                // Create default exercises in WorkoutBuddy
                                for (Exercise ex in Exercise.defaultExercises) {
                                  await _db.addExercise(ex);
                                }
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  loading = false;
                                  errorMsg = e.message!;
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
              ),
            ],
          ),
        ),
      );
    }
  }
}
