import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Settings'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // const SizedBox(height: 20),
            Row(
              children: const [
                SizedBox(height: 30),
                Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.lightBlue,
                ),
                SizedBox(width: 15),
                Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            changeDetail(context, "username"),
            changeDetail(context, "password"),
          ],
        ),
      ),
    );
  }

  GestureDetector changeDetail(BuildContext context, String detail) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Change $detail"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration:
                          formInputDecoration.copyWith(hintText: "New $detail"),
                      validator: (input) {
                        if (input != null && input.isEmpty) {
                          return 'Enter your new $detail';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        child: Text(
                          "Change $detail",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          // Check if form is valid.
                          // if (_formKey.currentState!.validate()) {
                          //   setState(() => loading = true);
                          //   try {
                          //     await _auth.register(email, password);
                          //   } on FirebaseAuthException catch (e) {
                          //     setState(() {
                          //       loading = false;
                          //       errorMsg = e.message!;
                          //     });
                          //   }
                          // }
                        }),
                    // TextFormField(),
                  ],
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Change $detail",
              // style: const TextStyle(fontSize: 20),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
