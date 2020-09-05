import 'package:flutter/material.dart';
import 'package:quran/baseurl/base_app.dart';
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
      debugShowCheckedModeBanner: Status.debug,
      home: PageSplash(),
      color: Colors.blue,
    );
  }
}
