import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import './particle.dart';

import '../models/pattern.dart';

class ParticleContainer extends StatefulWidget {
  final Pattern pattern;
  final bool isBreathing;
  final double diameter;
  final double offsetRadius;

  ParticleContainer(
      {@required this.pattern,
      @required this.isBreathing,
      @required this.diameter,
      @required this.offsetRadius});
  @override
  _ParticleContainerState createState() => _ParticleContainerState();
}

class _ParticleContainerState extends State<ParticleContainer>
    with SingleTickerProviderStateMixin {
  static const beginTween = 1.0;
  static const endTween = 0.01;
  double _xOffset;
  double _yOffset;

  Timer _inhalePauseTimer;
  Timer _exhalePauseTimer;

  AnimationController _translateController;
  Animation _curve;
  Animation<double> _translation;

  @override
  void initState() {
    super.initState();
    _xOffset = Random().nextDouble() *
        widget.offsetRadius *
        (Random().nextDouble() < 0.5 ? -1 : 1);
    final _maxY = sqrt(pow(widget.offsetRadius, 2) - pow(_xOffset, 2));
    _yOffset =
        Random().nextDouble() * _maxY * (Random().nextDouble() < 0.5 ? -1 : 1);

    _translateController = AnimationController(
      duration: Duration(milliseconds: (widget.pattern.exhale * 1000).toInt()),
      reverseDuration:
          Duration(milliseconds: (widget.pattern.inhale * 1000).toInt()),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _curve = CurvedAnimation(
        parent: _translateController, curve: Curves.easeInOutSine)
      ..addStatusListener(handleAnimationStatus);

    _translation = Tween<double>(
      begin: beginTween,
      end: endTween,
    ).animate(_curve);
  }

  @override
  void didUpdateWidget(ParticleContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBreathing) {
      _translateController.forward();
    } else {
      _translateController.stop();
      _translateController.reset();
    }

    if ((widget.pattern.inhale != oldWidget.pattern.inhale ||
            widget.pattern.exhale != oldWidget.pattern.exhale) &&
        _translateController != null) {
      _translateController.duration =
          Duration(milliseconds: (widget.pattern.exhale * 1000).toInt());
      _translateController.reverseDuration =
          Duration(milliseconds: (widget.pattern.inhale * 1000).toInt());
    }
  }

  @override
  void dispose() {
    _translateController.dispose();
    _inhalePauseTimer.cancel();
    _exhalePauseTimer.cancel();
    super.dispose();
  }

  void handleAnimationStatus(AnimationStatus status) {
    if (!widget.isBreathing) return;
    if (status == AnimationStatus.completed) {
      if (widget.pattern.exhalePause <= 0.0) {
        _translateController.reverse();
      } else {
        _exhalePauseTimer = Timer(
            Duration(milliseconds: (widget.pattern.exhalePause * 1000).toInt()),
            () => _translateController.reverse());
      }
    } else if (status == AnimationStatus.dismissed) {
      if (widget.pattern.inhalePause <= 0.0) {
        _translateController.forward();
      } else {
        _inhalePauseTimer = Timer(
            Duration(milliseconds: (widget.pattern.inhalePause * 1000).toInt()),
            () => _translateController.forward());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset(
            _xOffset * _translation.value, _yOffset * _translation.value),
        child: Particle(
          diameter: widget.diameter,
        ));
  }
}
