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
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  bool _hasNewName = false;
  bool _hasNewCal = false;
  bool _isValidCal = true;

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
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
                  controller: _controller1,
                  decoration: formInputDecoration.copyWith(
                      hintText: 'Change snack name'),
                ),
                TextField(
                  controller: _controller2,
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
                  setState(() {
                    _hasNewName = _controller1.text.isNotEmpty;
                    _hasNewCal = _controller2.text.isNotEmpty;
                    _isValidCal = num.tryParse(_controller2.text) != null &&
                        num.parse(_controller2.text) >= 0;

                    if (!_isValidCal && _hasNewCal) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Enter a positive number'),
                        ),
                      );
                    }
                  });

                  if (_hasNewName) {
                    // Change both name and cals
                    if (_hasNewCal && _isValidCal) {
                      await _db
                          .updateSnackName(widget.snack, _controller1.text)
                          .then((value) => _db.updateSnack(Snack(
                              name: _controller1.text,
                              calories: num.parse(_controller2.text))))
                          .whenComplete(() {
                        _controller1.clear();
                        _controller2.clear();
                        Navigator.of(dialogContext).pop();
                      });
                    }
                    // Only change name
                    if (!_hasNewCal) {
                      await _db
                          .updateSnackName(widget.snack, _controller1.text)
                          .whenComplete(() {
                        _controller1.clear();
                        _controller2.clear();
                        Navigator.of(dialogContext).pop();
                      });
                    }
                  } else {
                    // Only change cals
                    if (_hasNewCal && _isValidCal) {
                      await _db
                          .updateSnack(Snack(
                              name: widget.snack.name,
                              calories: num.parse(_controller2.text)))
                          .whenComplete(() {
                        _controller1.clear();
                        _controller2.clear();
                        Navigator.of(dialogContext).pop();
                      });
                    }
                  }
                }),
            TextButton(
              child: const Text(
                'Delete snack',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await _db.deleteSnack(widget.snack).whenComplete(() {
                  Navigator.of(dialogContext).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
