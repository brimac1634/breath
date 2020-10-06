import 'package:flutter/material.dart';

import './incrementer.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Inhale Time',
                // style: TextStyle(color: Colors.red),
              )
            ],
          )
        ],
      ),
    );
  }
}
