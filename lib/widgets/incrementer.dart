import 'package:flutter/material.dart';

class Incrementer extends StatelessWidget {
  final double value;
  final Function onChange;

  Incrementer({@required this.value, @required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              onChange(value - 0.5);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.white))),
              child: Text(
                '-',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              value.toString(),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          GestureDetector(
            onTap: () {
              onChange(value + 0.5);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.white))),
              child: Text(
                '+',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
