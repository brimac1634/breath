import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import './incrementer.dart';
import './color_picker.dart';

import '../assets/breathe_icons.dart';

import '../models/pattern.dart';

class Menu extends StatelessWidget {
  final Pattern pattern;
  final Color color;
  final bool hasVibrator;
  final bool vibrationEnabled;
  final Function(Color) setColor;
  final Function onVibrationChange;
  final Function onPatternChange;
  final Function onSave;

  Menu(
      {@required this.pattern,
      @required this.color,
      @required this.hasVibrator,
      @required this.vibrationEnabled,
      @required this.setColor,
      @required this.onVibrationChange,
      @required this.onPatternChange,
      this.onSave});

  Widget renderOptions(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Inhale Time',
                  style: Theme.of(context).textTheme.bodyText1,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Exhale Time',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Incrementer(
                  value: pattern.exhale,
                  onChange: (value) {
                    onPatternChange(Pattern(
                        inhale: pattern.inhale,
                        exhale: value,
                        inhalePause: pattern.inhalePause,
                        exhalePause: pattern.exhalePause));
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Inhale Pause',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Incrementer(
                  value: pattern.inhalePause,
                  onChange: (value) {
                    onPatternChange(Pattern(
                        inhale: pattern.inhale,
                        exhale: pattern.exhale,
                        inhalePause: value,
                        exhalePause: pattern.exhalePause));
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Exhale Pause',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Incrementer(
                  value: pattern.exhalePause,
                  onChange: (value) {
                    onPatternChange(Pattern(
                        inhale: pattern.inhale,
                        exhale: pattern.exhale,
                        inhalePause: pattern.inhalePause,
                        exhalePause: value));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderResetButton(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (hasVibrator)
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Opacity(
            opacity: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Vibration',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(
                      BreatheIcons.vibrate,
                      color: vibrationEnabled ? color : Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      if (!hasVibrator) return;
                      if (!vibrationEnabled) Vibration.vibrate(duration: 150);
                      onVibrationChange(!vibrationEnabled);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ColorPicker(
          width: min(350, MediaQuery.of(context).size.width * 0.8),
          currentColor: color,
          setColor: setColor,
        ),
      ),
      SizedBox(
        height: 40,
      ),
      OutlineButton(
        highlightedBorderColor: const Color(0xfff0dfea),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        borderSide:
            BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Text('Reset', style: Theme.of(context).textTheme.bodyText1),
        onPressed: () {
          setColor(Color(0xfffc00a3));
          onPatternChange(Pattern(
              inhale: 5.5, exhale: 5.5, inhalePause: 0, exhalePause: 0));
          onVibrationChange(false);
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Container(
        // constraints: BoxConstraints(maxWidth: 400.0),
        padding: EdgeInsets.all(20),
        child: Stack(children: [
          orientation == Orientation.portrait
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  renderOptions(context),
                  renderResetButton(context)
                ])
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: renderOptions(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: renderResetButton(context),
                    )
                  ],
                ),
          Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  onPressed: () {
                    onSave();
                  },
                ),
              ))
        ]),
      ),
    );
  }
}
