import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/widgets/loading.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangePassword> {
  final _auth = AuthService();
  final _pwController = TextEditingController();
  final _newPwController1 = TextEditingController();
  final _newPwController2 = TextEditingController();

  bool loading = false;
  bool _validate1 = true;
  bool _validate2 = true;
  bool _validate3 = true;
  String errorMsg = '';

  @override
  void dispose() {
    _pwController.dispose();
    _newPwController1.dispose();
    _newPwController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Health==Wealth'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: _pwController,
                  decoration: formInputDecoration
                      .copyWith(hintText: 'Current password')
                      .copyWith(
                          errorText: _validate1
                              ? null
                              : 'Password must have at least 6 characters'),
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: _newPwController1,
                  decoration: formInputDecoration
                      .copyWith(hintText: 'New password')
                      .copyWith(
                          errorText: _validate2
                              ? null
                              : 'New password must be different'),
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: _newPwController2,
                  decoration: formInputDecoration
                      .copyWith(hintText: 'Re-enter password')
                      .copyWith(
                          errorText:
                              _validate3 ? null : 'Enter the same password!'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text(
                    'Change password',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _validate1 = _pwController.text.length > 5;
                      _validate2 = (_newPwController1.text.isNotEmpty &&
                          _pwController.text != _newPwController1.text);
                      _validate3 =
                          (_newPwController2.text == _newPwController1.text);
                    });
                    if (_validate1 && _validate2 && _validate3) {
                      setState(() => loading = true);
                      try {
                        await _auth.changePassword(
                            _pwController.text, _newPwController1.text);
                        setState(() {
                          loading = false;
                          _validate1 = true;
                          _validate2 = true;
                          _validate3 = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password changed successfully'),
                            ),
                          );
                          Navigator.pop(context);
                        });
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          // _pwController.clear();
                          // _newPwController1.clear();
                          FocusScope.of(context).unfocus();
                          loading = false;
                          errorMsg = e.message!;
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 25.0),
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
      );
    }
  }
}
