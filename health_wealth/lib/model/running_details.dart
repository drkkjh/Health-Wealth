import 'package:cloud_firestore/cloud_firestore.dart';

class RunningDetails {
  String id;
  String date;
  String duration;
  double speed;
  double distance;
  DateTime dateTime;

  RunningDetails(
      {required this.id,
      required this.date,
      required this.duration,
      required this.speed,
      required this.distance,
      required this.dateTime});

  static RunningDetails fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return RunningDetails(
      id: snapshot['id'],
      date: snapshot['date'],
      duration: snapshot['duration'],
      speed: snapshot['speed'],
      distance: snapshot['distance'],
      dateTime: snapshot['dateTime'].toDate(),
    );
  }
}
