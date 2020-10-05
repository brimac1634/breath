import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/particles.dart';

import '../models/pattern.dart';

class BreatheScreen extends StatefulWidget {
  @override
  _BreatheScreenState createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen> {
  Pattern _pattern =
      Pattern(inhale: 5.5, exhale: 5.5, inhalePause: 0, exhalePause: 0);
  bool _isBreathing = false;

  void toggleBreath() {
    setState(() {
      _isBreathing = !_isBreathing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: toggleBreath,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Particles(
              pattern: _pattern,
              isBreathing: _isBreathing,
              quantity: 30,
              diameter: 6.0,
            ),
            Particles(
              pattern: _pattern,
              isBreathing: _isBreathing,
              quantity: 25,
              diameter: 8.0,
            ),
            Particles(
              pattern: _pattern,
              isBreathing: _isBreathing,
              quantity: 15,
              diameter: 10.0,
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
