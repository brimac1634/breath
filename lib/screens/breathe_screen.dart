import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:math';

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
  bool _hasVibrator = false;
  bool _vibrationEnabled = true;

  Timer _breathTimer;
  Timer _breathInterval;
  List<int> _vibrationPattern;

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

    Vibration.hasVibrator().then((hasVibrator) {
      setState(() {
        _hasVibrator = hasVibrator;
        if (hasVibrator) {
          _vibrationPattern = _getVibrationPattern(
              incrementMultiple: 1.5,
              milliseconds: _pattern.inhale * 1000,
              vibrationDuration: 100);
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _breathTimer.cancel();
    _breathInterval.cancel();
    super.dispose();
  }

  void toggleBreath() {
    print(_getVibrationPattern(
        incrementMultiple: 1.7,
        milliseconds: _pattern.inhale * 1000,
        vibrationDuration: 100));
    if (_hasVibrator && _vibrationEnabled && _vibrationPattern != null) {
      if (!_isBreathing) {
        _breathTimer = Timer(
            Duration(
                milliseconds: (_pattern.exhale + _pattern.exhalePause).toInt() *
                    1000), () {
          Vibration.vibrate(pattern: _vibrationPattern);
          _breathInterval = Timer.periodic(
              Duration(
                  milliseconds: (_pattern.inhale +
                              _pattern.inhalePause +
                              _pattern.exhale +
                              _pattern.exhalePause)
                          .toInt() *
                      1000), (_) {
            Vibration.vibrate(pattern: _vibrationPattern);
          });
        });
      } else {
        _breathTimer.cancel();
        _breathInterval.cancel();
      }
    }
    setState(() {
      _isBreathing = !_isBreathing;
    });
  }

  List<int> _getVibrationPattern(
      {double incrementMultiple,
      double milliseconds,
      double vibrationDuration}) {
    var halfOfDuration = milliseconds / 2;
    var halfVibrationCount = (halfOfDuration * 0.0028).floor();
    var halfDurationLessVibrations =
        halfOfDuration - (halfVibrationCount * vibrationDuration);
    var r = (1 - incrementMultiple) /
        (1 - pow(incrementMultiple, halfVibrationCount));
    var baseInterval = halfDurationLessVibrations * r;
    List<int> halfOfIntervals = [];
    List<int> secondHalfOfIntervals = [];
    for (var i = 0; i < halfVibrationCount; i++) {
      halfOfIntervals.add(vibrationDuration.floor());
      halfOfIntervals.add((baseInterval * pow(incrementMultiple, i)).floor());
      secondHalfOfIntervals
          .add((baseInterval * pow(incrementMultiple, i)).floor());
      secondHalfOfIntervals.add(vibrationDuration.floor());
    }
    return [...halfOfIntervals.reversed, ...secondHalfOfIntervals];
  }

  void _toggleMenu() {
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
              opacity: _isBreathing || _showingMenu ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: _toggleMenu,
              ),
            )
          ]),
        ),
        AnimatedOpacity(
          opacity: 1 - _opacity,
          duration: _animationDuration,
          curve: _animationCurve,
          child: IgnorePointer(
            ignoring: !_showingMenu,
            child: Menu(
                pattern: _pattern,
                vibrationEnabled: _vibrationEnabled,
                onVibrationChange: (vibration) {
                  setState(() {
                    _vibrationEnabled = vibration;
                  });
                },
                onPatternChange: (pattern) {
                  setState(() {
                    _pattern = pattern;
                  });
                },
                onSave: () {
                  _toggleMenu();
                }),
          ),
        )
      ]),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
