//Light mode toggle

import 'package:flutter/material.dart';

class SnakePage extends StatefulWidget {
  const SnakePage({Key? key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const SnakePage(),
      );
  @override
  _SnakePageState createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
       body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[100],
            child: Image.asset('images/cat1.jpg'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[200],
            child: Image.asset('images/cat2.jpg'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[300],
            child: Image.asset('images/cat3.jpg'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[400],
            child: Image.asset('images/cat4.jpg'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[500],
            child: Image.asset('images/cat5.jpg'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[600],
            child: Image.asset('images/cat6.jpg'),
          ),
        ],
      )


    );
  }
}
