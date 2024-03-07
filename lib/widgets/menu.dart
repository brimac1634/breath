import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'incrementor.dart';
import './color_picker.dart';

import '../assets/breathe_icons.dart';

import '../models/pattern.dart';

class Menu extends StatefulWidget {
  final Pattern pattern;
  final Color color;
  final bool hasVibrator;
  final bool vibrationEnabled;
  final Function(Color) setColor;
  final Function onVibrationChange;
  final Function onPatternChange;
  final Function? onSave;

  Menu(
      {required this.pattern,
      required this.color,
      required this.hasVibrator,
      required this.vibrationEnabled,
      required this.setColor,
      required this.onVibrationChange,
      required this.onPatternChange,
      this.onSave});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  double _colorPickerWidth = 0;
  double _colorSliderPosition = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _colorPickerWidth = min(350, MediaQuery.of(context).size.width * 0.8);
      _colorSliderPosition = _colorPickerWidth * 0.9;
    });
  }

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
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Incrementor(
                  value: widget.pattern.inhale,
                  onChange: (value) {
                    widget.onPatternChange(Pattern(
                        inhale: value,
                        exhale: widget.pattern.exhale,
                        inhalePause: widget.pattern.inhalePause,
                        exhalePause: widget.pattern.exhalePause));
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
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Incrementor(
                  value: widget.pattern.exhale,
                  onChange: (value) {
                    widget.onPatternChange(Pattern(
                        inhale: widget.pattern.inhale,
                        exhale: value,
                        inhalePause: widget.pattern.inhalePause,
                        exhalePause: widget.pattern.exhalePause));
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
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Incrementor(
                  value: widget.pattern.inhalePause,
                  onChange: (value) {
                    widget.onPatternChange(Pattern(
                        inhale: widget.pattern.inhale,
                        exhale: widget.pattern.exhale,
                        inhalePause: value,
                        exhalePause: widget.pattern.exhalePause));
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
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Incrementor(
                  value: widget.pattern.exhalePause,
                  onChange: (value) {
                    widget.onPatternChange(Pattern(
                        inhale: widget.pattern.inhale,
                        exhale: widget.pattern.exhale,
                        inhalePause: widget.pattern.inhalePause,
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
      if (widget.hasVibrator)
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(
                      BreatheIcons.vibrate,
                      color:
                          widget.vibrationEnabled ? widget.color : Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      if (!widget.hasVibrator) return;
                      if (!widget.vibrationEnabled)
                        Vibration.vibrate(duration: 150);
                      widget.onVibrationChange(!widget.vibrationEnabled);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ColorPicker(
        width: _colorPickerWidth,
        currentColor: widget.color,
        setColor: widget.setColor,
        colorSliderPosition: _colorSliderPosition,
        setColorSliderPosition: (double position) {
          setState(() {
            _colorSliderPosition = position;
          });
        },
      ),
      SizedBox(
        height: 40,
      ),
      OutlinedButton(
        // highlightedBorderColor: const Color(0xfff0dfea),
        // borderSide:
        //     BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid),
        style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)))),
        child: Text('Reset', style: Theme.of(context).textTheme.bodyLarge),
        onPressed: () {
          widget.setColor(Color(0xfffc00a3));
          widget.onPatternChange(Pattern(
              inhale: 5.5, exhale: 5.5, inhalePause: 0, exhalePause: 0));
          widget.onVibrationChange(false);
          setState(() {
            _colorSliderPosition = _colorPickerWidth * 0.9;
          });
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Container(
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
                    if (widget.onSave != null) {
                      widget.onSave!();
                    }
                  },
                ),
              ))
        ]),
      ),
    );
  }
}
