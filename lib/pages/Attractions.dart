import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mad_assignment_03/pages/Settings.dart';

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
      body: FutureBuilder<List<Attraction>>(
        future: httpService.getAttractions(),
        builder: (BuildContext context, AsyncSnapshot<List<Attraction>> snapshot) {
          if (snapshot.hasData) {
            List<Attraction>? attractions = snapshot.data;
            return ListView.builder(
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
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class HttpService {
  final String attractionsURL = "https://CptFlashbang.github.io/mad_assignment_03/apiAttractions.json";

  Future<List<Attraction>> getAttractions() async {
    http.Response res = await http.get(Uri.parse(attractionsURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Attraction> attractions = body.map((dynamic item) => Attraction.fromJson(item)).toList();
      return attractions;
    } else {
      throw Exception("Unable to retrieve attractions.");
    }
  }
}

class Attraction {
  final String attractionID;
  final String attractionTitle;
  final String attractionDescription;

  Attraction({required this.attractionID, required this.attractionTitle, required this.attractionDescription});

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      attractionID : json['attractionID'] as String,
      attractionTitle: json['attractionTitle'] as String,
      attractionDescription: json['attractionDescription'] as String,
    );
  }
}

class AttractionDetail extends StatelessWidget {
  final Attraction attraction;

  const AttractionDetail({
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
        ],
      ),
    );
  }
}
