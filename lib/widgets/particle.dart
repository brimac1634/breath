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
  final _start = Random().nextDouble().round().toDouble();
  double _offsetX;
  double _offsetY;
  AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      duration: Duration(
          seconds: (widget.diameter * Random().nextDouble()).toInt() + 2),
      vsync: this,
    )..repeat();

    final _offset =
        widget.diameter * Random().nextDouble() + (widget.diameter * 0.5);

    _offsetX = Random().nextDouble() < 0.5 ? -_offset : _offset;
    _offsetY = Random().nextDouble() < 0.5 ? -_offset : _offset;
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
            color: const Color(0xfff0dfea),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xfffc00a3),
                blurRadius: 10.0,
                spreadRadius: 1.2,
              ),
            ]),
      ),
    );
  }
}
