import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/common/loading.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final _auth = AuthService();
  late final _db = DatabaseService();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  bool loading = false;
  bool _validate1 = true;
  bool _validate2 = true;
  String errorMsg = '';

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
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
          actions: [
            TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              icon: const Icon(Icons.person),
              label: const Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20.0),
              TextField(
                autofocus: true,
                controller: _controller1,
                decoration: formInputDecoration
                    .copyWith(hintText: "New username")
                    .copyWith(
                        errorText: _validate1
                            ? null
                            : 'Username must have at least 6 characters'),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _controller2,
                decoration: formInputDecoration
                    .copyWith(hintText: "Re-enter username")
                    .copyWith(
                        errorText:
                            _validate2 ? null : 'Re-enter the same username'),
              ),
              ElevatedButton(
                  child: const Text(
                    "Change username",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _validate1 = _controller1.text.length > 5;
                      _validate2 = (_controller2.text.isNotEmpty &&
                          _controller2.text == _controller1.text);
                    });
                    if (_validate1 && _validate2) {
                      setState(() => loading = true);
                      try {
                        await _db.updateUsername(_controller1.text);
                      } on FirebaseException catch (e) {
                        setState(() {
                          loading = false;
                          errorMsg = e.message!;
                        });
                      } on UsernameTakenException catch (e) {
                        loading = false;
                        errorMsg = e.message;
                      }
                      setState(() {
                        loading = false;
                        _validate1 = true;
                        _validate2 = true;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            // TODO: Show error message is there's one
                            content: Text('Username changed successfully'),
                          ),
                        );
                        Navigator.pop(context);
                      });
                    }
                  }),
              const SizedBox(height: 20.0),
              const SizedBox(height: 5.0),
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
      );
    }
  }
}
