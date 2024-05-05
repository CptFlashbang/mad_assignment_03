import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mad_assignment_03/attractionModel.dart';
import 'package:mad_assignment_03/pages/Settings.dart';
import 'package:mad_assignment_03/database_service.dart';
import 'package:mad_assignment_03/pages/camera.dart';
import 'package:path_provider/path_provider.dart';

class AttractionsPage extends StatefulWidget {
  const AttractionsPage({Key? key}) : super(key: key);

  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const AttractionsPage(),
      );

  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  final HttpService httpService = HttpService();
  List<Attraction>? attractions;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    updateAttractions();
    timer =
        Timer.periodic(Duration(seconds: 60), (Timer t) => updateAttractions());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateAttractions() async {
    attractions = await httpService.getAttractions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attractions"),
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
      ),
      body: attractions == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: attractions?.length ?? 0,
              itemBuilder: (context, index) {
                var attraction = attractions![index];
                return ListTile(
                  title: Text(attraction.attractionTitle),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AttractionDetail(
                          attraction: attraction,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class HttpService {
  final String attractionsURL =
      "https://CptFlashbang.github.io/mad_assignment_03/apiAttractions.json";

  Future<List<Attraction>> getLocalAttractions() async {
    final String jsonString =
        await rootBundle.loadString('assets/attractions.json');
    List<dynamic> body = jsonDecode(jsonString);
    List<Attraction> attractions =
        body.map((dynamic item) => Attraction.fromJson(item)).toList();
    return attractions;
  }

  Future<List<Attraction>> getAttractions() async {
    try {
      http.Response res = await http.get(Uri.parse(attractionsURL));

      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        List<Attraction> attractions =
            body.map((dynamic item) => Attraction.fromJson(item)).toList();
        return attractions;
      } else {
        throw Exception("Unable to retrieve attractions.");
      }
    } catch (_) {
      return getLocalAttractions();
    }
  }
}

class Attraction {
  final String attractionID;
  final String attractionTitle;
  final String attractionDescription;
  bool isSaved; // Add a flag to manage saved state

  Attraction({
    required this.attractionID,
    required this.attractionTitle,
    required this.attractionDescription,
    this.isSaved = false,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      attractionID: json['attractionID'] ?? 'defaultID', // Provide a default ID
      attractionTitle:
          json['attractionTitle'] ?? 'No title', // Provide a default title
      attractionDescription: json['attractionDescription'] ??
          'No description', // Provide a default description
      isSaved: false,
    );
  }
}

class AttractionDetail extends StatelessWidget {
  final Attraction attraction;
  final DatabaseService dbService =
      DatabaseService(); // Database service instance

  AttractionDetail({
    Key? key,
    required this.attraction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(attraction.attractionTitle),
      ),
      body: Column(
        children: [
          Text("Name: ${attraction.attractionTitle}"),
          Text("Description: ${attraction.attractionDescription}"),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async {
              try {
                AttractionModel attractionModel = AttractionModel(
                    id: attraction.attractionID,
                    name: attraction.attractionTitle,
                    saved: attraction.isSaved);
                await dbService.insertAttraction(attractionModel);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${attraction.attractionTitle} saved!'),
                ));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to save: $e'),
                ));
              }
            },
          ),
          ElevatedButton(
            child: const Text("Delete"),
            onPressed: () async {
              await dbService.deleteAttraction(attraction.attractionID);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${attraction.attractionTitle} deleted!'),
              ));
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraPage()),
              );
            },
            child: const Text('Scan fast pass'),
          ),
        ],
      ),
    );
  }
}
