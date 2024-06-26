import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lottie/lottie.dart' as l;

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => MapSampleState();
}

class MapSampleState extends State<MapsPage> {
  late String _mapStyle;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late LatLng _currentPosition;
  static final Random _random = Random();
  late List<Marker> markers = [];
  bool inTheCircle = false;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    rootBundle.loadString('assets/map.txt').then((string) {
      _mapStyle = string;
    });
  }

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _generateMarkers();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _generateMarkers() {
    for (int i = 0; i < 5; i++) {
      double lat = _currentPosition.latitude +
          (_random.nextDouble() - 0.5) * 0.01; // Randomize within 0.01 degrees
      double lng = _currentPosition.longitude +
          (_random.nextDouble() - 0.5) * 0.01; // Randomize within 0.01 degrees
      LatLng pos = LatLng(lat, lng);
      markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: pos,
          onTap: () {
            print('Marker tapped');
          },
        ),
      );
      inspect(markers);
    }
  }

  double calculateDistance(LatLng userPosition, LatLng markerPosition) {
    return Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        markerPosition.latitude,
        markerPosition.longitude);
  }

  void checkProximity(LatLng userPosition) {
    for (Marker marker in markers) {
      double distance = calculateDistance(userPosition, marker.position);
      if (distance <= 1) {
        setState(() {
          inTheCircle = true;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: inTheCircle
          ? ElevatedButton(
              onPressed: () {
                _showMyDialog();
              },
              child: Text(
                'Collect Your Reward',
                style: GoogleFonts.varelaRound(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            )
          : Container(),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                var mapController = controller;
                mapController.setMapStyle(_mapStyle);
              },
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 17,
              ),
              markers: Set.from(markers),
              circles: Set.from(markers.map((marker) => Circle(
                    circleId: CircleId(marker.markerId.value),
                    center: marker.position,
                    radius: 100, // Adjust the radius of the circle as needed
                    fillColor: Colors.blue.withOpacity(0.2),
                    strokeWidth: 0,
                  ))),
              onCameraMove: (CameraPosition position) {
                LatLng userPosition = position.target;
                checkProximity(userPosition);
              },
            ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                l.Lottie.asset('assets/cong.json'),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '50 Coins have been added to your account',
                    style: GoogleFonts.varelaRound(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Great!'),
              onPressed: () {
                setState(() {
                  inTheCircle = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
