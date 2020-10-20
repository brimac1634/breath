import 'package:flutter/material.dart';

import './incrementer.dart';
import '../assets/breathe_icons.dart';

import '../models/pattern.dart';

class Menu extends StatelessWidget {
  final Pattern pattern;
  final bool vibrationEnabled;
  final Function onVibrationChange;
  final Function onPatternChange;
  final Function onSave;

  Menu(
      {@required this.pattern,
      @required this.vibrationEnabled,
      @required this.onVibrationChange,
      @required this.onPatternChange,
      this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400.0),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          Padding(
            padding: const EdgeInsets.all(20.0),
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
                      color:
                          vibrationEnabled ? Color(0xfffc00a3) : Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      onVibrationChange(!vibrationEnabled);
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          OutlineButton(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            borderSide: BorderSide(
                color: Colors.white, width: 1, style: BorderStyle.solid),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            child: Text('Save', style: Theme.of(context).textTheme.bodyText1),
            onPressed: () {
              onSave();
            },
          )
        ],
      ),
    );
  }
}
