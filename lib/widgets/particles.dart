import 'package:flutter/material.dart';
import 'dart:math';

import './particle_container.dart';

import '../models/pattern.dart';

class Particles extends StatelessWidget {
  final Pattern pattern;
  final bool isBreathing;
  final int quantity;
  final double diameter;

  Particles(
      {@required this.pattern,
      @required this.isBreathing,
      @required this.quantity,
      @required this.diameter});

  @override
  Widget build(BuildContext context) {
    final _radius = min(MediaQuery.of(context).size.width * 0.4,
        MediaQuery.of(context).size.height * 0.4);

    return Stack(
        children: List.generate(
      quantity,
      (index) {
        return Center(
            child: ParticleContainer(
                pattern: pattern,
                diameter: diameter,
                duration: (diameter * Random().nextDouble()).toInt() + 2,
                offset: diameter * Random().nextDouble() + (diameter * 0.5),
                offsetRadius: _radius,
                isBreathing: isBreathing));
      },
    ));
  }
}
