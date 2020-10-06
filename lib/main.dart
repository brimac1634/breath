import 'package:breath/screens/breathe_screen.dart';
import 'package:flutter/material.dart';

import './screens/breathe_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breath',
      theme: ThemeData(
        primaryColor: Colors.white,
        // textTheme: Theme.of(context).textTheme.apply(
        //       bodyColor: Colors.white,
        //       displayColor: Colors.white,
        //     ),
        backgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BreatheScreen(),
    );
  }
}
