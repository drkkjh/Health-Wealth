import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/database.dart';

class SnackTile extends StatefulWidget {
  final Snack snack;

  const SnackTile({Key? key, required this.snack}) : super(key: key);

  @override
  State<SnackTile> createState() => _SnackTileState();
}

class _SnackTileState extends State<SnackTile> {
  final _db = DatabaseService();
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
        child: GestureDetector(
          onTap: _openDialog,
          child: ListTile(
            title: Text(widget.snack.name),
            subtitle: Text('Calories: ${widget.snack.calories}'),
          ),
        ),
      ),
    );
  }

  Future _openDialog() {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Update snack details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _textController1,
                  decoration: formInputDecoration.copyWith(
                      hintText: 'Change snack name'),
                ),
                TextField(
                  controller: _textController2,
                  keyboardType: TextInputType.number,
                  decoration: formInputDecoration.copyWith(
                      hintText: 'Change calories content'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update snack'),
              onPressed: () async {
                num cal = num.tryParse(_textController2.text) ??
                    widget.snack.calories;
                if (_textController1.text.isEmpty) {
                  await _db.updateSnackCalories(
                      Snack(name: widget.snack.name, calories: cal));
                } else {
                  await _db.addSnack(
                      Snack(name: _textController1.text, calories: cal));
                  await _db.deleteSnack(widget.snack);
                }
                _textController1.clear();
                _textController2.clear();
                if (!mounted) return;
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete snack',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await _db.deleteSnack(widget.snack);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
