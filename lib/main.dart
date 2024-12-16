
import 'package:flutter/material.dart';

import 'homesceen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      title: "Image Frame app",
      theme: ThemeData(
        primarySwatch: Colors.cyan
      ),
    );
  }
}
