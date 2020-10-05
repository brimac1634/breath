import 'package:flutter/material.dart';
import 'dart:math';

class Particle extends StatefulWidget {
  final double diameter;
  final int duration;
  final double offset;

  Particle({
    @required this.diameter,
    @required this.duration,
    @required this.offset,
  });
  @override
  _ParticleState createState() => _ParticleState();
}

class _ParticleState extends State<Particle>
    with SingleTickerProviderStateMixin {
  static const _colors = [Colors.red, Colors.white, Colors.blue];
  final _start = Random().nextDouble().round().toDouble();
  final _color = _colors[Random().nextInt(_colors.length)];
  double _offsetX;
  double _offsetY;
  AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    )..repeat();

    _offsetX = Random().nextDouble() < 0.5 ? -widget.offset : widget.offset;
    _offsetY = Random().nextDouble() < 0.5 ? -widget.offset : widget.offset;
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: _start, end: _start == 0.0 ? 1.0 : 0.0)
          .animate(_rotateController),
      child: Container(
        width: widget.diameter,
        height: widget.diameter,
        transform: Matrix4.translationValues(_offsetX, _offsetY, 0),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
