import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mad_assignment_03/pages/Settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _menuItems = []; // This will hold menu items after loading

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    final String response = await rootBundle.loadString('assets/cafeMenu.json');
    final data = await json.decode(response);
    setState(() {
      _menuItems = data['cafeMenu'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
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
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: _menuItems.length, // Count of menu items
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(_menuItems[index]['name']),
                subtitle: Text(_menuItems[index]['description']),
                trailing: Text("\$${_menuItems[index]['price']}"),
              ),
            );
          },
        ),


class WeatherNetworkService {
  static Future<Weather> getWeatherData(lat, lon) async {
    String myKey = "4a5b40d08fb85eaa51451bee38fecb28";
    String openWeatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon& units=metric&appid=$myKey";

    var response = await http.get(Uri.parse(openWeatherUrl));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return Weather.fromJson(jsonResponse);
    } else {
      throw Exception(response.statusCode);
    }
  }
}

class Weather {
  //model for weather api
  String name;
  double temperature;
  double temperatureFeeling;
  String weatherPic;

  Weather(
      this.name, this.temperature, this.temperatureFeeling, this.weatherPic);

  factory Weather.fromJson(Map<String, dynamic> jsonResponse) => Weather(
      jsonResponse["name"],
      jsonResponse["main"]["temp"],
      jsonResponse["main"]["feels_like"],
      jsonResponse["weather"][0]["main"]);
}
      ),
    );
  }
}
