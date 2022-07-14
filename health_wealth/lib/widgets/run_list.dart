import 'package:flutter/material.dart';
import 'package:health_wealth/widgets/running_card.dart';
import 'package:health_wealth/model/runningdetails.dart';
import 'package:provider/provider.dart';

class RunList extends StatefulWidget {
  const RunList({Key? key}) : super(key: key);

  @override
  State<RunList> createState() => _RunListState();
}

class _RunListState extends State<RunList> {
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<List<RunningDetails>>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return RunningCard(runningdetails: list[index]);
        },
      ),
    );
  }
}
