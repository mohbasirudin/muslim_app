import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:quran/baseurl/base_app.dart';
import 'package:quran/view/page_main.dart';

class PageSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    startApp(context);
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "MuslimApp",
              style: TextStyle(fontSize: Size.size24, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.85),
            child: JumpingDotsProgressIndicator(
              fontSize: Size.size32,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  startApp(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return PageMain();
      }));
    });
  }
}
