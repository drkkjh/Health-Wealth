import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/common/input_validator.dart';
import 'package:health_wealth/services/database.dart';

class UpdateCalLimitPanel extends StatefulWidget {
  const UpdateCalLimitPanel({Key? key}) : super(key: key);

  @override
  State<UpdateCalLimitPanel> createState() => _UpdateExerciseState();
}

class _UpdateExerciseState extends State<UpdateCalLimitPanel> {
  final _formKey = GlobalKey<FormState>();

  final _db = DatabaseService();
  num _limit = 1000;

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
                child: Text('Set Daily Calories Limit',
                    style: TextStyle(fontSize: 20))),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration:
                  formInputDecoration.copyWith(hintText: 'limit (kcal)'),
              validator: InputValidator.validateCalories,
              onChanged: (val) {
                setState(() {
                  if (num.tryParse(val) != null) {
                    _limit = num.parse(val);
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
                    await _db.updateCalLimit(_limit).whenComplete(() {
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
