import 'package:flutter/material.dart';
import 'package:quran/view/page_splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageSplash(),
      color: Colors.blue,
    );
  }
}
