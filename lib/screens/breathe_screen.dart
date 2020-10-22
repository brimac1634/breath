import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:math';

import '../widgets/particles.dart';
import '../widgets/menu.dart';
import '../assets/breathe_icons.dart';

import '../models/pattern.dart';

class BreatheScreen extends StatefulWidget {
  @override
  _BreatheScreenState createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with TickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 400);
  static const _animationCurve = Curves.easeInOut;
  Pattern _pattern =
      Pattern(inhale: 5.5, exhale: 5.5, inhalePause: 0, exhalePause: 0);
  double _opacity = 1.0;
  bool _isBreathing = false;
  bool _showingMenu = false;
  bool _hasVibrator = false;
  bool _vibrationEnabled = false;

  Timer _breathTimer;
  Timer _breathInterval;
  List<int> _vibrationPattern;

  AnimationController _controller;
  Animation _curve;
  Animation<double> _blurFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _animationDuration, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _blurFade = Tween<double>(begin: 4.0, end: 0.0).animate(_controller);

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
    if (_isBreathing) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

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
        Vibration.cancel();
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
    return WillPopScope(
      onWillPop: () async {
        if (_showingMenu) {
          _toggleMenu();
          return false;
        }
      },
      child: Scaffold(
        body: Stack(children: [
          IgnorePointer(
            ignoring: _showingMenu,
            child: GestureDetector(
              onTap: toggleBreath,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  Particles(
                    pattern: _pattern,
                    isBreathing: _isBreathing,
                    quantity: [30, 30, 20],
                    diameter: [4.0, 5.0, 6.0],
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: _blurFade.value, sigmaY: _blurFade.value),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(children: [
                        AnimatedOpacity(
                          duration: _animationDuration,
                          curve: _animationCurve,
                          opacity: !_isBreathing ? 1.0 : 0.0,
                          child: Text(
                            '.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Center(
                          child: AnimatedOpacity(
                            duration: _animationDuration,
                            curve: _animationCurve,
                            opacity: _isBreathing || _showingMenu ? 0.0 : 1.0,
                            child: Text(
                              'On Tap: Breathe Out',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              AnimatedOpacity(
                opacity: _isBreathing || _showingMenu ? 0.0 : 1.0,
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
      ),
    );
  }
}
