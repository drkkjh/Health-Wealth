import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/model/exercise.dart';
import 'package:health_wealth/services/database.dart';

class UpdateExercisePanel extends StatefulWidget {
  final Exercise exercise;
  const UpdateExercisePanel({Key? key, required this.exercise})
      : super(key: key);

  @override
  State<UpdateExercisePanel> createState() => _UpdateExerciseState();
}

class _UpdateExerciseState extends State<UpdateExercisePanel> {
  final _formKey = GlobalKey<FormState>();

  final _db = DatabaseService();
  late int _sets = widget.exercise.sets;
  late int _reps = widget.exercise.reps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Update exercise', style: TextStyle(fontSize: 20))),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: formInputDecoration.copyWith(hintText: 'sets'),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return null;
                } else if (int.tryParse(val) == null) {
                  return 'Enter a integer';
                } else {
                  return null;
                }
              },
              onChanged: (val) {
                setState(() {
                  if (int.tryParse(val) != null) {
                    _sets = int.parse(val);
                  }
                });
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: formInputDecoration.copyWith(hintText: 'reps'),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return null;
                } else if (int.tryParse(val) == null) {
                  return 'Enter an integer';
                } else {
                  return null;
                }
              },
              onChanged: (val) {
                setState(() {
                  if (int.tryParse(val) != null) {
                    _reps = int.parse(val);
                  }
                });
              },
            ),
            ElevatedButton(
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  // Check if form is valid.
                  if (_formKey.currentState!.validate()) {
                    await _db
                        .updateExercise(Exercise(
                            name: widget.exercise.name,
                            sets: _sets,
                            reps: _reps))
                        .whenComplete(() {
                      Navigator.of(context).pop();
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
