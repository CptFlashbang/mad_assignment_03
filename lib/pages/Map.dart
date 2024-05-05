import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mad_assignment_03/pages/Settings.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Adding Wolverhampton marker
    _markers.add(
      Marker(
        markerId: MarkerId('wolverhampton'),
        position: LatLng(52.5870, -2.1289),
        infoWindow: InfoWindow(
          title: 'Wolverhampton',
          snippet: 'Marker in Wolverhampton, England',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your location'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              child: const Text('Settings'),
            ),
          ],
          elevation: 2,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(52.5870, -2.1289), // You can change this to LatLng(52.5870, -2.1289) if you want the camera to start at Wolverhampton
            zoom: 11.0,
          ),
          markers: _markers,
        ),
      ),
    );
  }
}
