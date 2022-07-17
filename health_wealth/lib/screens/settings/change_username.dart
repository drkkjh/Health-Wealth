import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/widgets/loading.dart';
import 'package:health_wealth/services/database.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final _db = DatabaseService();
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
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
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
                const SizedBox(height: 15),
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
                        setState(() {
                          loading = false;
                          _validate1 = true;
                          _validate2 = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Username changed successfully'),
                            ),
                          );
                          Navigator.pop(context);
                        });
                      } on FirebaseException catch (e) {
                        setState(() {
                          loading = false;
                          errorMsg = e.message!;
                        });
                      } on UsernameTakenException catch (e) {
                        setState(() {
                          _controller1.clear();
                          _controller2.clear();
                          loading = false;
                          errorMsg = e.message;
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
