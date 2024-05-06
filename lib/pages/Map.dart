import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
    fetchAttractions();
  }

  void fetchAttractions() async {
    final String attractionsURL = "https://CptFlashbang.github.io/mad_assignment_03/apiAttractions.json";
    try {
      http.Response res = await http.get(Uri.parse(attractionsURL));
      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        List<Marker> markers = body.map((dynamic item) {
          LatLng latLng = LatLng(item['latitude'].toDouble(), item['longitude'].toDouble());
          return Marker(
            markerId: MarkerId(item['attractionID']),
            position: latLng,
            infoWindow: InfoWindow(
              title: item['attractionTitle'],
              snippet: item['attractionDescription'],
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
        }).toList();
        setState(() {
          _markers = Set.from(markers);
        });
      }
    } catch (e) {
      print('Failed to load attractions: $e');
    }
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
            target: LatLng(52.5870, -2.1289),
            zoom: 11.0,
          ),
          markers: _markers,
        ),
      ),
    );
  }
}
