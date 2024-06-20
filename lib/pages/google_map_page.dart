import 'package:alumni_circle_app/components/floating_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/utils/constants.dart';

class GoogleMapPage extends StatefulWidget {
  final Events? event;

  const GoogleMapPage({Key? key, this.event}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage>
    with SingleTickerProviderStateMixin {
  final Location locationController = Location();
  GoogleMapController? mapController;

  LatLng? currentPosition;
  LatLng? mountainView;
  Map<PolylineId, Polyline> polylines = {};

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      mountainView = LatLng(widget.event!.latitude, widget.event!.longitude);
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await initializeMap();
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Load icons for markers from assets
    loadMarkerIcons();
  }

  Future<void> loadMarkerIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1000, 1000)),
      'assets/images/source.png',
    );
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1000, 1000)),
      'assets/images/destination.png',
    );
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    if (currentPosition != null && mountainView != null) {
      final coordinates =
          await fetchPolylinePoints(currentPosition!, mountainView!);
      generatePolyLineFromPoints(coordinates);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Destination to ${widget.event?.namaEvent}',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: primaryFontColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 13,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  markers: {
                    if (currentPosition != null)
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: currentPosition!,
                        icon: sourceIcon ?? BitmapDescriptor.defaultMarker,
                        onTap: () {
                          _showEventDetailsDialog();
                        },
                      ),
                    if (mountainView != null)
                      Marker(
                        markerId: MarkerId('destinationLocation'),
                        position: mountainView!,
                        icon: destinationIcon ?? BitmapDescriptor.defaultMarker,
                        onTap: () {
                          _showEventDetailsDialog();
                        },
                      ),
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
          Positioned(
            top: 70,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  child: Icon(
                    Icons.zoom_in,
                    color: primaryFontColor,
                  ),
                ),
                SizedBox(height: 10.0),
                FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  child: Icon(Icons.zoom_out, color: primaryFontColor),
                ),
                SizedBox(height: 10.0),
                FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    if (currentPosition != null) {
                      mapController?.animateCamera(
                        CameraUpdate.newLatLng(currentPosition!),
                      );
                    }
                  },
                  child: Icon(Icons.my_location, color: primaryFontColor),
                ),
              ],
            ),
          ),
          SlideTransition(
            position: _offsetAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 100.0),
                child: FloatingContainer(
                  event: widget.event,
                  onClose: () {
                    _controller.reverse();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Future<List<LatLng>> fetchPolylinePoints(
      LatLng origin, LatLng destination) async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey, // Ganti dengan API key Google Maps Anda
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
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

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    final id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() {
      polylines[id] = polyline;
    });
  }

  void _showEventDetailsDialog() {
    _controller.forward();
  }
}
