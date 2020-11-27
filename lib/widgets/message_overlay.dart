import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:async';

import '../models/pattern.dart';

class MessageOverlay extends HookWidget {
  final bool isBreathing;
  final Curve animationCurve;
  final Pattern pattern;

  MessageOverlay(
      {@required this.isBreathing,
      @required this.animationCurve,
      @required this.pattern});

  @override
  Widget build(BuildContext context) {
    final _showBreathMessage = useState(false);
    final _breathMessage = useState('');

    useEffect(
      () {
        Timer _breatheInTimer;

        if (!isBreathing) {
          if (_breatheInTimer != null) {
            _breatheInTimer.cancel();
          }
          _showBreathMessage.value = false;
        } else {
          // step 1
          _breatheInTimer = Timer(Duration(seconds: 2), () {
            _breathMessage.value = 'Breathe In';
            _showBreathMessage.value = true;

            // step 2
            _breatheInTimer = Timer(Duration(seconds: 3), () {
              _showBreathMessage.value = false;

              // step 3
              _breatheInTimer = Timer(Duration(seconds: 1), () {
                _breathMessage.value = 'Breathe Out';
                _showBreathMessage.value = true;

                // step 4
                _breatheInTimer = Timer(
                    Duration(
                        milliseconds: (((pattern.exhale * 0.8) + 0.5) * 1000)
                            .toInt()), () {
                  _showBreathMessage.value = false;

                  // step 5
                  _breatheInTimer = Timer(
                      Duration(
                          milliseconds: (((pattern.exhale * 0.2) +
                                      pattern.exhalePause +
                                      (pattern.inhale * 0.1)) *
                                  1000)
                              .toInt()), () {
                    _breathMessage.value = 'Breathe In';
                    _showBreathMessage.value = true;

                    _breatheInTimer = Timer(
                        Duration(
                            milliseconds:
                                (pattern.inhale * 0.8 * 1000).toInt()), () {
                      _showBreathMessage.value = false;
                    });
                  });
                });
              });
            });
          });
        }

        return () {
          if (_breatheInTimer != null) {
            _breatheInTimer.cancel();
          }
        };
      },
      [isBreathing],
    );

    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        height: MediaQuery.of(context).size.height * 0.35,
        child: Center(
          child: AnimatedOpacity(
            opacity: _showBreathMessage.value ? 1 : 0,
            duration: Duration(milliseconds: 600),
            curve: animationCurve,
            child: Text(
              _breathMessage.value,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ));
  }
}
