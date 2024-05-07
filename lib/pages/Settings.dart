import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:battery_plus/battery_plus.dart';
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
  
  final Battery _battery = Battery();
  String _batteryLevel = 'Unknown battery level';

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initBatteryLevel();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Could not check connectivity status');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus == ConnectivityResult.mobile) {
        _connText = "Mobile data";
      } else if (_connectionStatus == ConnectivityResult.wifi) {
        _connText = "Wifi";
      } else if (_connectionStatus == ConnectivityResult.none) {
        _connText = "No connection";
      } else {
      _connText = "someat else";
      }
    });
  }

  Future<void> initBatteryLevel() async {
    int batteryLevel;
    try {
      batteryLevel = await _battery.batteryLevel;
    } catch (e) {
      batteryLevel = -1;
    }

    setState(() {
      _batteryLevel = batteryLevel == -1 ? 'Failed to get battery level' : '$batteryLevel%';
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
            Text('Network info: $_connText'),
            Text('Battery life: $_batteryLevel'),
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
