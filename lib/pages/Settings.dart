import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      );
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media;
    media = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('Network info'),
            Text('Battery life'),
            ElevatedButton(
              child: const Text("Button 1"),
              onPressed: () {
                // _getLastLocation();
              },
            ),
            ElevatedButton(
              child: const Text("Button 2"),
              onPressed: () {
                // _getLastLocation();
              },
            ),
            ElevatedButton(
              child: const Text("Button 3"),
              onPressed: () {
                // _getLastLocation();
              },
            ),
          ],
        ),
      ),
    );
  }
}
