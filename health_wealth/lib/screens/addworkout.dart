import 'package:flutter/material.dart';
import 'package:health_wealth/model/workoutcard.dart';

class AddWorkOut extends StatefulWidget {
  const AddWorkOut({Key? key}) : super(key: key);

  @override
  State<AddWorkOut> createState() => _AddWorkOutState();
}

class _AddWorkOutState extends State<AddWorkOut> {
  String? _result;
  final _textController = TextEditingController();

  Widget addTemplate(workout) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: WorkoutCard(workout: workout),
    );
  }

  void _addWorkout() {
    String textToSend = _textController.text;
    Navigator.of(context).pop(textToSend);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        TextField(
          controller: _textController,
        ),
        ElevatedButton(
          onPressed: _addWorkout,
          child: const Text('Add'),
        ),
        const SizedBox(height: 30),
        Text(
          _result == null ? 'Please enter a workout!' : _result.toString(),
          style: const TextStyle(fontSize: 20),
        )
      ]),
    ));
  }
}
