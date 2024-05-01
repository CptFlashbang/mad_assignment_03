import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
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
      body: FutureBuilder(
        future: httpService.getAttractions(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Attraction>> snapshot) {
          if (snapshot.hasData) {
            List<Attraction>? attractions = snapshot.data;
            return ListView(
              children: attractions!
                  .map(
                    (Attraction attraction) => ListTile(
                      title: Text(attraction.attractionTitle),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AttractionDetail(
                            attraction: attraction,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(child: Text("Not fetching"));
          }
        },
      ),
    );
  }
}

class HttpService {
  final String attractionsURL =
      "https://CptFlashbang.github.io/mad_assignment_03/apiAttractions.json";

  Future<List<Attraction>> getAttractions() async {
    Response res = await get(Uri.parse(attractionsURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Attraction> attractions = body
          .map(
            (dynamic item) => Attraction.fromJson(item),
          )
          .toList();

      return attractions;
    } else {
      throw "Unable to retrieve attractions.";
    }
  }
}

class Attraction {
  final String attractionTitle;
  final String attractionDescription;

  Attraction(
      {required this.attractionTitle, required this.attractionDescription});

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
        attractionTitle: json['attractionTitle'] as String,
        attractionDescription: json['attractionDescription'] as String);
  }
}

class AttractionDetail extends StatelessWidget {
  final Attraction attraction;
  const AttractionDetail({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(attraction.attractionTitle),
        ),
        body: Column(children: [
          Text("Name: ${attraction.attractionTitle}"),
          Text("Description: ${attraction.attractionDescription}")
        ]));
  }
}
