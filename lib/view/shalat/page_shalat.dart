import 'package:flutter/material.dart';
import 'package:quran/baseurl/base_app.dart';
import 'package:quran/view/page_main.dart';
import 'package:quran/view/shalat/flexible_appbar.dart';

class PageShalat extends StatefulWidget {
  const PageShalat({Key key, @required this.location}) : super(key: key);
  final String location;
  @override
  _PageShalatState createState() => _PageShalatState();
}

class _PageShalatState extends State<PageShalat> {
  var _location;
  var _statusBarHeight = 0.0, _appBarHeight = 0.0;
  @override
  void initState() {
    _location = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _statusBarHeight = MediaQuery.of(context).padding.top;
    _appBarHeight = AppBar().preferredSize.height;

    return MaterialApp(
        home: Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, scrolling) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.green,
                  pinned: true,
                  leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => PageMain()))),
                  expandedHeight: 220,
                  forceElevated: scrolling,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _location,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        Func.getTime(Format.time_1),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                  actions: [
                    IconButton(
                        icon: Icon(
                          Icons.sync,
                          color: Colors.white,
                        ),
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {})
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                    padding: EdgeInsets.only(
                        top: _statusBarHeight + _appBarHeight + 16,
                        left: 16,
                        right: 16),
                    color: Colors.teal,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Shubuh',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            Text('Shubuh',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        )
                      ],
                    ),
                  )),
                ),
              )
            ];
          },
          body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => Container(
              color: (index % 2 == 0) ? Colors.blue : Colors.red,
              height: 200,
            ),
          )),
    ));
  }

  Widget itemShalat(List<String> data, int index) {
    return InkWell();
  }
}
