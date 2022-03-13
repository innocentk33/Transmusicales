import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transmusicales/utils/data_utils.dart';

class ArtistMap extends StatefulWidget {
  final String title;
  const ArtistMap({Key? key, required this.title}) : super(key: key);

  @override
  _ArtistMapStateState createState() => _ArtistMapStateState();
}

class _ArtistMapStateState extends State<ArtistMap> {

  late GoogleMapController mapController;
  late Position _currentPosition;
  late LatLng _center = LatLng(5.37796973150617, -3.96620526419914);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<Circle> circles = [];
  List<Marker> markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

    });

    circles.add(Circle(
      circleId: CircleId("1"),
      center: _center,
      fillColor: const Color.fromARGB(70, 150, 50, 50),
      strokeColor: Colors.red,
      radius: 2000,
      strokeWidth: 1,
      consumeTapEvents: true,
    ));

    markers.add(Marker(
      markerId: MarkerId("1"),
      position: _center,
      infoWindow: InfoWindow(
          title: "datasets[i].artistes",
          snippet: "datasets[i].annee.toString()"),
    ));

  }

  Widget artistMap(BuildContext context) {

    Set<Circle> circle = Set.from(circles);
    Set<Marker> marker = Set.from(markers);

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Text(widget.title),
            Expanded(
              child: SizedBox(
                  child: Center(
                    child: GoogleMap(
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                                  () => PanGestureRecognizer()))
                          ..add(Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer())),
                        tiltGesturesEnabled: true,
                        trafficEnabled: true,
                        onMapCreated: _onMapCreated,
                        mapToolbarEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 9,
                        ),
                        circles: circle,
                        markers: marker),
                  )),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
          body: artistMap(context)),
    );
  }
}