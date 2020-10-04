import 'package:flutter/material.dart';

import './widgets/particles.dart';

import './models/pattern.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breath',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Pattern pattern =
      Pattern(inhale: 0.5, exhale: 0.5, inhalePause: 0, exhalePause: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Particles()),
    );
  }
}
