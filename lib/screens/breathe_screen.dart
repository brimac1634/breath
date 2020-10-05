import 'package:flutter/material.dart';

import '../widgets/particles.dart';

import '../models/pattern.dart';

class BreatheScreen extends StatefulWidget {
  @override
  _BreatheScreenState createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen> {
  Pattern _pattern =
      Pattern(inhale: 0.5, exhale: 0.5, inhalePause: 0, exhalePause: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Particles(
            pattern: _pattern,
            quantity: 30,
            diameter: 6.0,
          ),
          Particles(
            pattern: _pattern,
            quantity: 25,
            diameter: 8.0,
          ),
          Particles(
            pattern: _pattern,
            quantity: 15,
            diameter: 10.0,
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
