import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/services/database.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({Key? key}) : super(key: key);

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  // User input variables
  String _name = '';
  int? _sets;
  int? _reps;

  void _addExercise() async {
    var newExercise = Exercise(name: _name, sets: _sets!, reps: _reps!);
    await _db
        .addExercise(newExercise)
        .whenComplete(() => Navigator.of(context).pop());
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
                            hintText: 'Enter exercise name'),
                        autofocus: true,
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Name of exercise';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (input) {
                          setState(() => _name = input);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: formInputDecoration.copyWith(
                            hintText: 'Number of sets'),
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Enter a number';
                          } else if (int.tryParse(input) == null ||
                              int.parse(input) < 0) {
                            return 'Enter a positive integer!';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (input) {
                          if (int.tryParse(input) != null) {
                            setState(() => _sets = int.parse(input));
                          }
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: formInputDecoration.copyWith(
                            hintText: 'Number of reps'),
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Enter a number';
                          } else if (int.tryParse(input) == null ||
                              int.parse(input) < 0) {
                            return 'Enter a positive integer!';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (input) {
                          if (int.tryParse(input) != null) {
                            setState(() => _reps = int.parse(input));
                          }
                        },
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addExercise();
                          }
                        },
                        child: const Text(
                          'Add exercise',
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
