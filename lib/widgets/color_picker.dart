import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final double width;
  final Color currentColor;
  final Function(Color) setColor;
  final double colorSliderPosition;
  final Function(double) setColorSliderPosition;

  ColorPicker(
      {@required this.width,
      @required this.currentColor,
      @required this.setColor,
      @required this.colorSliderPosition,
      @required this.setColorSliderPosition});
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> _colors = [
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 127, 0, 255),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 255, 0, 127),
    Color.fromARGB(255, 128, 128, 128),
  ];

  _colorChangeHandler(double position) {
    if (position > widget.width) {
      position = widget.width;
    }
    if (position < 0) {
      position = 0;
    }

    widget.setColorSliderPosition(position);
    widget.setColor(_calculateSelectedColor(position));
  }

  Color _calculateSelectedColor(double position) {
    double positionInColorArray =
        (position / widget.width * (_colors.length - 1));

    int index = positionInColorArray.truncate();

    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      return _colors[index];
    } else {
      int redValue = _colors[index].red == _colors[index + 1].red
          ? _colors[index].red
          : (_colors[index].red +
                  (_colors[index + 1].red - _colors[index].red) * remainder)
              .round();
      int greenValue = _colors[index].green == _colors[index + 1].green
          ? _colors[index].green
          : (_colors[index].green +
                  (_colors[index + 1].green - _colors[index].green) * remainder)
              .round();
      int blueValue = _colors[index].blue == _colors[index + 1].blue
          ? _colors[index].blue
          : (_colors[index].blue +
                  (_colors[index + 1].blue - _colors[index].blue) * remainder)
              .round();
      return Color.fromARGB(255, redValue, greenValue, blueValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            onTapDown: (TapDownDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child:
                  Stack(alignment: AlignmentDirectional.centerStart, children: [
                Container(
                  width: widget.width,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(colors: _colors),
                      border: Border.all(color: Colors.white, width: 1)),
                ),
                Transform.translate(
                  offset: Offset(widget.colorSliderPosition - 25, 0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: widget.currentColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1)),
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
