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
  }

  Future weatherFuture =
      WeatherNetworkService.getWeatherData(53.0162014, -2.1812607);

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
        body: ListView(
          padding: EdgeInsets.all(10.0),
          children: [
            Expanded(
              child: Column(
                children: [
                   Image.asset('images/park_entrance.jpg'), // Ensure you have an image in assets              
                  const Text(
                    "Welcome to Robert's Rodeo - Adventure Awaits!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: FutureBuilder(
                    future: weatherFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        return WeatherDataWidget(
                          weather: snapshot.data,
                        );
                      } else if (snapshot.hasError) {
                        children = <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        ];
                      } else {
                        children = const <Widget>[
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting result...'),
                          ),
                        ];
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: children,
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Plan Your Visit!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Find all the information you need about park hours, ticket prices, special events, and more. Make sure to check out our seasonal promotions!",
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Stay Connected!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Follow us on social media for the latest news and exclusive behind-the-scenes content. Share your moments with us using #RobertsRodeo!",
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ));
  }
}

class WeatherNetworkService {
  static Future<Weather> getWeatherData(lat, lon) async {
    String myKey = "4a5b40d08fb85eaa51451bee38fecb28";
    String openWeatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$myKey";

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

class WeatherDataWidget extends StatelessWidget {
  final Weather weather;

  const WeatherDataWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            weather.name,
            style: const TextStyle(
              fontSize: 50,
            ),
          ),
          Text(
            weather.weatherPic,
            style: const TextStyle(
              fontSize: 50,
            ),
          ),
          Text(
            "${weather.temperature.toStringAsFixed(2)}°C",
            style: const TextStyle(fontSize: 50),
          ),
          weather.temperatureFeeling < 15.0
              ? const Icon(
                  Icons.cloud,
                  color: Colors.grey,
                  size: 72,
                )
              : const Icon(
                  Icons.wb_sunny,
                  color: Colors.yellow,
                  size: 72,
                )
        ],
      ),
    );
  }
}
