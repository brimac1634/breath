import 'package:flutter/material.dart';

class Particle extends StatefulWidget {
  @override
  _ParticleState createState() => _ParticleState();
}

class _ParticleState extends State<Particle> with TickerProviderStateMixin {
  double dx = 1;
  double dy = 1;
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )
      ..repeat(reverse: true)
      ..forward();

    _animation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: const Offset(0.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   width: 20,
    //   height: 20,
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: Colors.red,
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //   ),
    // );
    return SlideTransition(
      position: _animation,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
