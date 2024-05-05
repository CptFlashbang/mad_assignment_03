import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      );
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _connText = "hello";
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Could not check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus == ConnectivityResult.mobile) {
        _connText = "mobile so it will eat your data";
      } else if (_connectionStatus == ConnectivityResult.wifi) {
        _connText = "wifi so go ahead and download";
      } else if (_connectionStatus == ConnectivityResult.none) {
        _connText = "no connection - try again later";
      } else {
        _connText = "someat else";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('Network info: $_connText'), // Corrected string interpolation
            Text('Battery life'),
            ElevatedButton(
              child: const Text("Button 1"),
              onPressed: () {
                // Implement or complete the functionality
              },
            ),
            ElevatedButton(
              child: const Text("Button 2"),
              onPressed: () {
                // Implement or complete the functionality
              },
            ),
            ElevatedButton(
              child: const Text("Button 3"),
              onPressed: () {
                // Implement or complete the functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
