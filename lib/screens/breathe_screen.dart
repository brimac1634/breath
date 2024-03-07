import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:math';

import '../widgets/particles.dart';
import '../widgets/menu.dart';
import '../widgets/message_overlay.dart';

import '../assets/breathe_icons.dart';

import '../models/pattern.dart';

class BreatheScreen extends StatefulWidget {
  @override
  _BreatheScreenState createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen> {
  static const _animationDuration = Duration(milliseconds: 400);
  static const _animationCurve = Curves.easeInOut;
  Pattern _pattern =
      Pattern(inhale: 5.5, exhale: 5.5, inhalePause: 0, exhalePause: 0);
  Color _color = Color(0xfffc00a3);
  double _opacity = 1.0;
  bool _showStart = true;
  bool _isBreathing = false;
  bool _showingMenu = false;
  bool _hasVibrator = false;
  bool _vibrationEnabled = false;

  late Timer _animationTimer;
  late Timer _startTimer;
  late Timer _breathTimer;
  late Timer _breathInterval;
  late List<int> _vibrationPattern;

  @override
  void initState() {
    super.initState();
    _calculateVibration(_pattern);
  }

  @override
  void dispose() {
    _breathTimer.cancel();
    _startTimer.cancel();
    _breathInterval.cancel();
    _animationTimer.cancel();
    super.dispose();
  }

  void _calculateVibration(Pattern pattern) {
    Vibration.hasVibrator().then((hasVibrator) {
      setState(() {
        _hasVibrator = hasVibrator ?? false;
        if (_hasVibrator) {
          _vibrationPattern = _getVibrationPattern(
              incrementMultiple: 1.5,
              milliseconds: pattern.inhale * 1000,
              vibrationDuration: 100);
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  void _toggleAnimationAndVibration() {
    if (_hasVibrator && _vibrationEnabled) {
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
        Vibration.cancel();
        _breathTimer.cancel();
        _breathInterval.cancel();
      }
    }
    setState(() {
      _isBreathing = !_isBreathing;
    });
  }

  void _toggleBreath() {
    if (!_showStart) {
      if (_isBreathing) {
        _toggleAnimationAndVibration();
      }
      _animationTimer.cancel();
    } else {
      _animationTimer = Timer(Duration(milliseconds: 6500), () {
        _toggleAnimationAndVibration();
      });
    }

    setState(() {
      _showStart = !_showStart;
    });
  }

  List<int> _getVibrationPattern(
      {required double incrementMultiple,
      required double milliseconds,
      required double vibrationDuration}) {
    var halfOfDuration = milliseconds / 2;
    var halfVibrationCount = (halfOfDuration * 0.0024).floor();
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
      setState(() {
        _opacity = 1.0;
      });
    } else {
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
    return PopScope(
      onPopInvoked: (didPop) {
        if (_showingMenu) {
          _toggleMenu();
          return;
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(children: [
          IgnorePointer(
            ignoring: _showingMenu,
            child: GestureDetector(
              onTap: _toggleBreath,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  Particles(
                    pattern: _pattern,
                    color: _color,
                    isBreathing: _isBreathing,
                    quantity: const [40, 40, 35],
                    diameter: const [4.0, 5.0, 6.0],
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(children: [
                        Text(
                          '.',
                          style: TextStyle(color: Colors.black),
                        ),
                        Center(
                          child: AnimatedOpacity(
                            duration: _animationDuration,
                            curve: _animationCurve,
                            opacity: !_showStart || _showingMenu ? 0.0 : 1.0,
                            child: Text(
                              'Tap to start',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
          MessageOverlay(
              isBreathing: !_showStart,
              animationCurve: _animationCurve,
              pattern: _pattern),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              AnimatedOpacity(
                opacity: !_showStart || _showingMenu ? 0.0 : 1.0,
                duration: _animationDuration,
                curve: _animationCurve,
                child: IconButton(
                  icon: Icon(
                    BreatheIcons.lungs,
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
              child: Container(
                color: Colors.black,
                child: Menu(
                    pattern: _pattern,
                    color: _color,
                    hasVibrator: _hasVibrator,
                    vibrationEnabled: _vibrationEnabled,
                    setColor: (Color color) {
                      setState(() {
                        _color = color;
                      });
                    },
                    onVibrationChange: (vibration) {
                      setState(() {
                        _vibrationEnabled = vibration;
                      });
                    },
                    onPatternChange: (pattern) {
                      setState(() {
                        _pattern = pattern;
                      });
                      _calculateVibration(pattern);
                    },
                    onSave: () {
                      _toggleMenu();
                    }),
              ),
            ),
          )
        ]),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
