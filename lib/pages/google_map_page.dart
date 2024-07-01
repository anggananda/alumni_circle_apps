import 'package:alumni_circle_app/components/floating_container.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:alumni_circle_app/dto/event.dart';

class GoogleMapPage extends StatefulWidget {
  final Events? event;

  const GoogleMapPage({Key? key, this.event}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final locationController = Location();

  LatLng? currentPosition;
  LatLng? destinationLocation;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    destinationLocation =
        LatLng(widget.event!.latitude, widget.event!.longitude);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    final coordinates = await fetchPolylinePoints();
    generatePolyLineFromPoints(coordinates);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Route to : ${widget.event!.namaEvent} 📍', style: const TextStyle(
        fontWeight: FontWeight.bold
      ),
    ),
    centerTitle: true,
    backgroundColor: primaryColor,
    ),
        body: currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPosition!,
                  zoom: 13,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    position: currentPosition!,
                    onTap: () {
                      debugPrint("hallo bro");
                    },
                  ),
                  Marker(
                    markerId: const MarkerId('destinationLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: destinationLocation!,
                    onTap: _showEventDetails,
                  )
                },
                polylines: Set<Polyline>.of(polylines.values),
              ),
      );

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }

  Future<List<LatLng>> fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCv1eZK_N9k5WM-CAXmed-7O2r4vi-WYRA",
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
      PointLatLng(
          destinationLocation!.latitude, destinationLocation!.longitude),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  Future<void> generatePolyLineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }

  void _showEventDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: FloatingContainer(
            event: widget.event,
            onClose: () => Navigator.of(context)
                .pop(), // Close pop-up when tapped anywhere
          ),
        );
      },
    );
  }
}
