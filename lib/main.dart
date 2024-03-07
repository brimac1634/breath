import 'package:flutter/material.dart';

import './screens/breathe_screen.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.white,
  background: Colors.black,
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breath',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16.0),
          titleMedium:
              TextStyle(color: Colors.blue, fontWeight: FontWeight.w900),
          displayLarge: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: colorScheme,
      ),
      home: BreatheScreen(),
    );
  }
}
