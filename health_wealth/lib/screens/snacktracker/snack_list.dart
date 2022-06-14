import 'package:flutter/material.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/screens/snacktracker/add_snack.dart';
import 'package:health_wealth/screens/snacktracker/snack_tile.dart';
import 'package:provider/provider.dart';

class SnackList extends StatelessWidget {
  const SnackList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final snacks = Provider.of<List<Snack>>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: snacks.length,
        itemBuilder: (context, index) {
          return SnackTile(snack: snacks[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'btn1',
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSnack()),
          );
        },
      ),
    );
  }
}
