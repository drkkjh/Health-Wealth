import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_wealth/model/runningdetails.dart';
import 'package:health_wealth/services/auth.dart';
import 'package:health_wealth/services/database.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Running extends StatefulWidget {
  const Running({Key? key}) : super(key: key);

  @override
  State<Running> createState() => _RunningState();
}

class _RunningState extends State<Running> {
  final Set<Polyline> polyline = {};
  final Location _location = Location();
  late GoogleMapController _mapController;
  final LatLng _center = const LatLng(1.3521, 103.8198);
  List<LatLng> route = [];

  double _dist = 0;
  late String _displayTime;
  late int _time;
  late int _finalTime;
  double _speed = 0;
  double _avgSpeed = 0;
  double _numberOfDifferentSpeedRecorded = 0;

  // Stopwatch to track user runtime
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute
        .start); // start stopwatch immediately when at this page
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double distToBeAdded;

    _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(
          event.latitude!,
          event
              .longitude!); //event will not be null so it it safe to force a non-null here
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 15)));

      if (route.isNotEmpty) {
        distToBeAdded = Geolocator.distanceBetween(route.last.latitude,
            route.last.longitude, loc.latitude, loc.longitude);
        _dist = _dist + distToBeAdded;
        int timeDuration = (_time - _finalTime);

        if (timeDuration != 0) {
          _speed = 3.6 * (distToBeAdded / (timeDuration / 100));
          if (_speed != 0) {
            _avgSpeed = _avgSpeed + _speed;
            _numberOfDifferentSpeedRecorded++;
          }
        }
      }
      _finalTime = _time;
      route.add(loc);

      polyline.add(Polyline(
          polylineId: PolylineId(event.toString()),
          visible: true,
          points: route,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Colors.lightBlue));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              polylines: polyline,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 12.0),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 40),
              height: 140,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  // Flexible(
                  //   child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "SPEED (KM/H)",
                            style: GoogleFonts.yanoneKaffeesatz(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            _speed.toStringAsFixed(2),
                            style: GoogleFonts.yanoneKaffeesatz(
                              fontSize: 30,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "DURATION",
                            style: GoogleFonts.yanoneKaffeesatz(
                              fontSize: 15,
                            ),
                          ),
                          StreamBuilder<int>(
                            stream: _stopWatchTimer.rawTime,
                            initialData: 0,
                            builder: (context, snap) {
                              _time = snap
                                  .data!; // snap.data will be of a non-null value so it is safe to force non-null here
                              _displayTime =
                                  "${StopWatchTimer.getDisplayTimeHours(_time)}:${StopWatchTimer.getDisplayTimeMinute(_time)}:${StopWatchTimer.getDisplayTimeSecond(_time)}";
                              return Text(
                                _displayTime,
                                style: GoogleFonts.yanoneKaffeesatz(
                                  fontSize: 30,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("DISTANCE CLOCKED (KM)",
                              style: GoogleFonts.yanoneKaffeesatz(
                                fontSize: 15,
                              )),
                          Text((_dist / 1000).toStringAsFixed(2),
                              style: GoogleFonts.yanoneKaffeesatz(
                                fontSize: 30,
                              ))
                        ],
                      )
                    ],
                  ),
                  // ),
                  const Divider(),
                  Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.stop_circle,
                        size: 70,
                        color: Colors.red[700],
                      ),
                      onPressed: () {
                        RunningDetails rd = RunningDetails(
                          id: AuthService().currentUser.uid,
                          date:
                              DateFormat.yMMMMd('en_US').format(DateTime.now()),
                          duration: _displayTime,
                          speed: _avgSpeed / _numberOfDifferentSpeedRecorded,
                          distance: _dist,
                        );
                        db.insertRun(rd);
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
