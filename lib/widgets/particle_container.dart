import 'package:flutter/material.dart';
import 'dart:math';

import './particle.dart';

import '../models/pattern.dart';

class ParticleContainer extends StatefulWidget {
  final Pattern pattern;
  final double diameter;
  final int duration;
  final double offset;
  final double offsetRadius;

  ParticleContainer(
      {@required this.pattern,
      @required this.diameter,
      @required this.duration,
      @required this.offset,
      @required this.offsetRadius});
  @override
  _ParticleContainerState createState() => _ParticleContainerState();
}

class _ParticleContainerState extends State<ParticleContainer>
    with SingleTickerProviderStateMixin {
  double _xOffset;
  double _yOffset;

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
      duration: Duration(milliseconds: widget.pattern.inhale.toInt() * 100),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        print(status.toString());
      });

    _curve = CurvedAnimation(
        parent: _translateController, curve: Curves.easeInOutSine);

    _translation = Tween<double>(
      begin: 1.0,
      end: 0.01,
    ).animate(_curve);

    _translateController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset(
            _xOffset * _translation.value, _yOffset * _translation.value),
        child: Particle(
          diameter: widget.diameter,
          duration: widget.duration,
          offset: widget.offset,
        ));
  }
}
