import 'package:flutter/material.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/services/database.dart';
import 'package:health_wealth/widgets/loading.dart';
import 'package:health_wealth/widgets/snack_tile.dart';

class SnackList extends StatefulWidget {
  const SnackList({Key? key}) : super(key: key);

  @override
  State<SnackList> createState() => _SnackListState();
}

class _SnackListState extends State<SnackList> {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Snack>>(
      initialData: const [],
      stream: _db.getSnacks,
      builder: (context, snapshot) {
        final snacks = snapshot.data;

        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snacks!.length,
              itemBuilder: (context, index) {
                return SnackTile(snack: snacks[index]);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20.0,
              ),
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
