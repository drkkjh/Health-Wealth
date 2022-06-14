import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/database.dart';

class AddSnack extends StatefulWidget {
  const AddSnack({Key? key}) : super(key: key);

  @override
  State<AddSnack> createState() => _AddSnackState();
}

class _AddSnackState extends State<AddSnack> {
  final _formKey = GlobalKey<FormState>();

  // User input variables
  String _name = '';
  num _calories = 0;

  void _addSnack() async {
    var newSnack = Snack(name: _name, calories: _calories);
    await DatabaseService().addSnack(newSnack);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Health==Wealth'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: formInputDecoration.copyWith(
                            hintText: 'Enter snack name'),
                        autofocus: true,
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Enter the name of the snack';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (input) {
                          setState(() => _name = input);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: formInputDecoration.copyWith(
                            hintText: 'Enter snack calories'),
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Enter a number';
                          } else if (num.tryParse(input) == null) {
                            return 'Enter a number!';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (input) {
                          if (num.tryParse(input) != null) {
                            setState(() => _calories = num.parse(input));
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addSnack();
                          }
                        },
                        child: const Text(
                          'Add snack',
                          style: TextStyle(color: Colors.white),
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
