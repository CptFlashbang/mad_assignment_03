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

typedef ItemSelectedCallback = void Function(int value);

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
  var isLargeScreen = false;
  late Attraction savedAttraction;

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
    MediaQueryData media;
    media = MediaQuery.of(context);
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
      body: FutureBuilder(
        future: httpService.getAttractions(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Attraction>> snapshot) {
          if (snapshot.hasData) {
            List<Attraction>? attractions = snapshot.data;
            savedAttraction = attractions![0];
            return OrientationBuilder(builder: (context, orientation) {
              if (media.size.width > 800) {
                isLargeScreen = true;
              } else {
                isLargeScreen = false;
              }
              return Row(children: <Widget>[
                Expanded(
                  child: ListWidget(attractions, (value) {
                    if (isLargeScreen) {
                      savedAttraction = attractions[value];
                      setState(() {});
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AttractionDetail(attraction: attractions[value]);
                      }));
                    }
                  }),
                ),
                isLargeScreen
                    ? Expanded(
                        flex: 2,
                        child: DetailWidget(attraction: savedAttraction))
                    : Container()
              ]);
            });
          } else {
            return Center(child: Text("Not fetching"));
          }
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
  final double latitude; // Added latitude
  final double longitude; // Added longitude

  Attraction({
    required this.attractionID,
    required this.attractionTitle,
    required this.attractionDescription,
    this.isSaved = false,
    required this.latitude, // Initialize latitude
    required this.longitude, // Initialize longitude
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      attractionID: json['attractionID'] ?? 'defaultID',
      attractionTitle: json['attractionTitle'] ?? 'No title',
      attractionDescription: json['attractionDescription'] ?? 'No description',
      isSaved: false,
      latitude: json['latitude'].toDouble(), // Parse latitude
      longitude: json['longitude'].toDouble(), // Parse longitude
    );
  }
}

class AttractionDetail extends StatelessWidget {
  final Attraction attraction;

  AttractionDetail({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(attraction.attractionTitle),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildVerticalLayout(context, attraction)
              : _buildHorizontalLayout(context, attraction);
        },
      ),
    );
  }
}

Widget _buildVerticalLayout(BuildContext context, Attraction attraction) {
  final DatabaseService dbService = DatabaseService();
  return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    // Image.network(attraction.animalPic),
    Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Text("Name: ${attraction.attractionTitle}"),
                Text("Age: ${attraction.attractionDescription}"),
              ])),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async {
              try {
                AttractionModel attractionModel = AttractionModel(
                  id: attraction.attractionID,
                  name: attraction.attractionTitle,
                  saved: attraction.isSaved,
                  description: attraction.attractionDescription,
                  latitude: attraction.latitude, // Pass latitude
                  longitude: attraction.longitude, // Pass longitude
                );

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
        ]))
  ]);
}

Widget _buildHorizontalLayout(BuildContext context, Attraction attraction) {
  final DatabaseService dbService = DatabaseService();
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image.network(attraction.animalPic),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text("Name: ${attraction.attractionTitle}"),
              Text("Age: ${attraction.attractionDescription}"),
            ])),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              ElevatedButton(
                child: const Text("Save"),
                onPressed: () async {
                  try {
                    AttractionModel attractionModel = AttractionModel(
                      id: attraction.attractionID,
                      name: attraction.attractionTitle,
                      saved: attraction.isSaved,
                      description: attraction.attractionDescription,
                      latitude: attraction.latitude, // Pass latitude
                      longitude: attraction.longitude, // Pass longitude
                    );

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
            ]))
      ]);
}

class ListWidget extends StatefulWidget {
  final List<Attraction> attractions;

  final ItemSelectedCallback onItemSelected;

  ListWidget(
    this.attractions,
    this.onItemSelected,
  );

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.attractions.length,
      itemBuilder: (context, position) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            child: InkWell(
              onTap: () {
                widget.onItemSelected(position);
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      widget.attractions[position].attractionTitle,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailWidget extends StatelessWidget {
  final Attraction attraction;
  final DatabaseService dbService = DatabaseService();
  DetailWidget({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 450),
          // child: Image.network(this.attraction.animalPic))),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Text("Name: ${this.attraction.attractionTitle}"),
                Text("Age: ${this.attraction.attractionDescription}"),
                ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () async {
                    try {
                      AttractionModel attractionModel = AttractionModel(
                        id: attraction.attractionID,
                        name: attraction.attractionTitle,
                        saved: attraction.isSaved,
                        description: attraction.attractionDescription,
                        latitude: attraction.latitude, // Pass latitude
                        longitude: attraction.longitude, // Pass longitude
                      );

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
              ]))
        ]);
  }
}
