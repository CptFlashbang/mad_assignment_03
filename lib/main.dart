import 'package:flutter/material.dart';
import 'package:mad_assignment_03/pages/login.dart';
import 'package:mad_assignment_03/pages/home.dart';
import 'package:mad_assignment_03/pages/attractions.dart';
import 'package:mad_assignment_03/pages/map.dart';
import 'package:mad_assignment_03/pages/snake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roberts Rodeo companion app',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(color: Color(0xFF391B92)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.deepOrange,
            backgroundColor: Color(0xFF391B92)),
      ),
      home: const Login(title: 'Roberts Rodeo companion app'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        // selectedItemColor: Colors.red,
        // unselectedItemColor: Colors.black45,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.title,
            )
        ],
      ),
    );
  }
}

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    required this.page,
    required this.title,
    required this.icon,
  });

  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: const HomePage(),
      icon: const Icon(Icons.home),
      title: "Home",
    ),
    TabNavigationItem(
      page: const AttractionsPage(),
      icon: const Icon(Icons.email),
      title: "Attractions",
    ),
    TabNavigationItem(
      page: const MapPage(),
      icon: const Icon(Icons.map),
      title: "Map",
    ),
    TabNavigationItem(
      page: const SnakePage(),
      icon: const Icon(Icons.games),
      title: "Snake",
    ),
  ];
}

