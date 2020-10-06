import 'package:flutter/material.dart';

import './incrementer.dart';

import '../models/pattern.dart';

class Menu extends StatelessWidget {
  final Pattern pattern;
  final Function onPatternChange;

  Menu({@required this.pattern, @required this.onPatternChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Inhale Time',
                style: Theme.of(context).textTheme.headline1,
              ),
              Incrementer(
                value: pattern.inhale,
                onChange: (value) {
                  onPatternChange(Pattern(
                      inhale: value,
                      exhale: pattern.exhale,
                      inhalePause: pattern.inhalePause,
                      exhalePause: pattern.exhalePause));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
