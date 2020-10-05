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
        backgroundColor: Colors.black,
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
      body: Stack(
        children: [
          Particles(
            quantity: 20,
            diameter: 6.0,
          ),
          Particles(
            quantity: 20,
            diameter: 8.0,
          ),
          Particles(
            quantity: 15,
            diameter: 10.0,
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
