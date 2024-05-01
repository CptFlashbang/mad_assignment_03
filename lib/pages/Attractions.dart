import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  List<String> favouriteAttractions = [];

  Future<Map<String, bool>> readFavourites() async {
  try {
    final String response = await rootBundle.loadString('assets/favourites.json');
    Map<String, dynamic> jsonMap = jsonDecode(response);

    return jsonMap.map((key, value) => MapEntry(key, value as bool));
  } catch (e) {
    print('Error reading favourites: $e');
    return {};
  }
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
      body: FutureBuilder(
        future: httpService.getAttractions(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Attraction>> snapshot) {
          if (snapshot.hasData) {
            List<Attraction>? attractions = snapshot.data;
            return ListView(
              children: attractions!
                  .map((Attraction attraction) => ListTile(
                        title: Text(attraction.attractionTitle),
                        onTap: () async {
                          Map<String, bool> favouriteAttractions =
                              await readFavourites();
                          print('Favourite attractions: $favouriteAttractions');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AttractionDetail(
                                attraction: attraction,
                                favouriteAttractions: favouriteAttractions,
                              ),
                            ),
                          );
                        },
                      ))
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

class AttractionDetail extends StatefulWidget {
  final Attraction attraction;
  final Map<String, bool> favouriteAttractions;

  const AttractionDetail({
    Key? key,
    required this.attraction,
    required this.favouriteAttractions,
  }) : super(key: key);

  @override
  _AttractionDetailState createState() => _AttractionDetailState();
}

class _AttractionDetailState extends State<AttractionDetail> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    // Initialize favorite status based on the passed data
    isFavourite = widget.favouriteAttractions[widget.attraction.attractionTitle] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.attraction.attractionTitle),
      ),
      body: Column(
        children: [
          Text("Name: ${widget.attraction.attractionTitle}"),
          Text("Description: ${widget.attraction.attractionDescription}"),
          Text('Favourited: $isFavourite'),
          IconButton(
            icon: Icon(
              isFavourite ? Icons.favorite : Icons.favorite_border,
              color: isFavourite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isFavourite = !isFavourite;
                // Optionally update the favorite status in a higher level state or data store
                widget.favouriteAttractions[widget.attraction.attractionTitle] = isFavourite;
              });
            },
          ),
        ],
      ),
    );
  }
}