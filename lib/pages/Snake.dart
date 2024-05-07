import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_snake/flutter_snake.dart';

class SnakePage extends StatefulWidget {
  const SnakePage({Key? key}) : super(key: key);

  @override
  _SnakePageState createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  StreamController<GAME_EVENT>? controller;
  SnakeGame? snakeGame;

  @override
  void initState() {
    super.initState();
    controller = StreamController<GAME_EVENT>();
    controller?.stream.listen((GAME_EVENT value) {
      print(value.toString());
    });

    snakeGame = new SnakeGame(
      caseWidth: 25.0,
      numberCaseHorizontally: 15,
      numberCaseVertically: 15,
      controllerEvent: controller,
      durationBetweenTicks: Duration(milliseconds: 2000),
      colorBackground1: Color(0XFF7CFC00),
      colorBackground2: Color(0XFF32CD32),
    );
  }

  @override
  void dispose() {
    controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Snake"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => snakeGame?.nextDirection = SNAKE_MOVE.left,
                  icon: Icon(Icons.subdirectory_arrow_left),
                ),
                Text("SNAKE"),
                IconButton(
                  onPressed: () => snakeGame?.nextDirection = SNAKE_MOVE.right,
                  icon: Icon(Icons.subdirectory_arrow_right),
                ),
              ],
            ),
            snakeGame ?? Text("Not initialized"),
          ],
        ),
      ),
    );
  }
}
