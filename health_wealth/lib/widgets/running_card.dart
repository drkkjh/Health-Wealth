import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_wealth/model/running_details.dart';

class RunningCard extends StatelessWidget {
  final RunningDetails runningDetails;
  const RunningCard({Key? key, required this.runningDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  runningDetails.date,
                  style: GoogleFonts.yanoneKaffeesatz(fontSize: 18),
                ),
                Text(
                  "${(runningDetails.distance / 1000.0).toStringAsFixed(2)} km",
                  style: GoogleFonts.yanoneKaffeesatz(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  runningDetails.duration,
                  style: GoogleFonts.yanoneKaffeesatz(fontSize: 14),
                ),
                Text(
                  "${runningDetails.speed.toStringAsFixed(2)} km/h",
                  style: GoogleFonts.yanoneKaffeesatz(fontSize: 14),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
