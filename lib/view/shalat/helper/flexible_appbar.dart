import 'package:flutter/material.dart';

class CustomFlexibleAppBar extends StatelessWidget {
  var statusBarHeight = 0.0;
  var appbarHeight = 66;
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: appbarHeight + statusBarHeight,
      child: Column(
        children: [],
      ),
    );
  }
}
