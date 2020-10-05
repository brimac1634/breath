import 'package:flutter/material.dart';
import 'dart:math';

class Particle extends StatefulWidget {
  final double diameter;
  final int duration;
  final double offset;

  Particle(
      {@required this.diameter,
      @required this.duration,
      @required this.offset});
  @override
  _ParticleState createState() => _ParticleState();
}

class _ParticleState extends State<Particle>
    with SingleTickerProviderStateMixin {
  final _start = Random().nextDouble().round().toDouble();
  static const _colors = [Colors.red, Colors.white, Colors.blue];
  // final _diameter = (Random().nextDouble() * 4) + 6;
  // final _duration = Random().nextInt(4) + 4;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: _start, end: _start == 0.0 ? 1.0 : 0.0)
          .animate(_controller),
      child: Container(
        width: widget.diameter,
        height: widget.diameter,
        transform: Matrix4.translationValues(
            Random().nextDouble() < 0.5 ? -widget.offset : widget.offset,
            Random().nextDouble() < 0.5 ? -widget.offset : widget.offset,
            0),
        decoration: BoxDecoration(
          color: _colors[Random().nextInt(_colors.length)],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
