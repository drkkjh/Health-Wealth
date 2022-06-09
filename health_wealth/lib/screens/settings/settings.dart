import 'package:flutter/material.dart';
import 'package:health_wealth/screens/settings/change_username.dart';

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
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text(
                      'Change username',
                      // style: const TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangeUsername()),
                );
              },
            ),
            // * Haven't implemented logic for 'Change password'
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text(
                      'Change password',
                      // style: const TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
