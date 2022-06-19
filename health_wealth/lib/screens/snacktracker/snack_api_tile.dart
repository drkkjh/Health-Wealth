import 'package:flutter/material.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/database.dart';

class SnackApiTile extends StatefulWidget {
  final Snack snack;

  const SnackApiTile({Key? key, required this.snack}) : super(key: key);

  @override
  State<SnackApiTile> createState() => _SnackTileState();
}

class _SnackTileState extends State<SnackApiTile> {
  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
        child: GestureDetector(
          onTap: () async {
            await _db.addSnack(widget.snack);
            if (!mounted) return;
            Navigator.pop(context);
          },
          child: ListTile(
            title: Text(widget.snack.name),
            subtitle: Text('Calories: ${widget.snack.calories}'),
          ),
        ),
      ),
    );
  }
}
