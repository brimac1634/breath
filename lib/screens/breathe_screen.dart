import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/particles.dart';
import '../widgets/menu.dart';

import '../models/pattern.dart';

class BreatheScreen extends StatefulWidget {
  @override
  _BreatheScreenState createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with TickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 1500);
  static const _animationCurve = Curves.easeInOutBack;
  Pattern _pattern =
      Pattern(inhale: 5.5, exhale: 5.5, inhalePause: 0, exhalePause: 0);
  double _opacity = 1.0;
  bool _isBreathing = false;
  bool _showingMenu = false;

  AnimationController _controller;
  Animation _curve;
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: _animationDuration,
        reverseDuration: Duration(milliseconds: 1200),
        vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _curve = CurvedAnimation(parent: _controller, curve: _animationCurve);
    _scale = Tween<double>(begin: 1.0, end: 3.0).animate(_curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleBreath() {
    setState(() {
      _isBreathing = !_isBreathing;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final _screenWidth = MediaQuery.of(context).size.width;
    // final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: [
        Transform.scale(
          scale: _scale.value,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: _animationDuration,
            curve: _animationCurve,
            child: GestureDetector(
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
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            AnimatedOpacity(
              opacity: _isBreathing ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: () {
                  if (_showingMenu) {
                    _controller.reverse();
                    setState(() {
                      _opacity = 1.0;
                    });
                  } else {
                    _controller.forward();
                    Future.delayed(Duration(milliseconds: 100), () {
                      setState(() {
                        _opacity = 0.0;
                      });
                    });
                  }
                  setState(() {
                    _showingMenu = !_showingMenu;
                  });
                },
              ),
            )
          ]),
        ),
        AnimatedOpacity(
          opacity: 1 - _opacity,
          duration: _animationDuration,
          curve: _animationCurve,
          child: Center(
            child: Menu(),
          ),
        )
      ]),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
