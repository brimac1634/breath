import 'package:flutter/material.dart';
import 'dart:math';

import './particle.dart';

class Particles extends StatefulWidget {
  final int quantity;
  final double diameter;

  Particles({@required this.quantity, @required this.diameter});
  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: List.generate(
      widget.quantity,
      (index) {
        final _radius = MediaQuery.of(context).size.width * 0.4;
        return Center(
          child: Transform(
              transform: Matrix4.translationValues(
                  Random().nextDouble() *
                      _radius *
                      (Random().nextDouble() < 0.5 ? -1 : 1),
                  Random().nextDouble() *
                      _radius *
                      (Random().nextDouble() < 0.5 ? -1 : 1),
                  0),
              child: Particle(
                diameter: widget.diameter,
                duration: (widget.diameter * Random().nextDouble()).toInt(),
                offset:
                    widget.diameter * Random().nextDouble() + widget.diameter,
              )),
        );
      },
    ));
  }
}
