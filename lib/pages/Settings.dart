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
        title: const Text("Home"),
      ),
      body: Container(
        

        ),
      );
  }
}

