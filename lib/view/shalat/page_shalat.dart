import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran/api/api_service.dart';
import 'package:quran/api/api_url.dart';
import 'package:quran/baseurl/base_app.dart';
import 'package:quran/model/shalat/response_shalat.dart' as shalat;
import 'package:quran/view/page_main.dart';

class PageShalat extends StatefulWidget {
  const PageShalat(
      {Key key,
      @required this.location,
      @required this.latitude,
      @required this.longitude})
      : super(key: key);
  final String location, latitude, longitude;
  @override
  _PageShalatState createState() => _PageShalatState();
}

class _PageShalatState extends State<PageShalat> {
  var _location = '', _latitude = '', _longitude = '', _urlJadwalShalat = '';
  List<shalat.Datetime> _listDatetime = List();
  var _statusBarHeight = 0.0, _appBarHeight = 0.0;
  @override
  void initState() {
    _location = widget.location;
    _latitude = widget.latitude;
    _longitude = widget.longitude;
    debugPrint('pageShalat: $_latitude, $_longitude');

    if (_location.isEmpty)
      _getCurrenyLocation();
    else
      _getData();
    super.initState();
  }

  Future _getCurrenyLocation() async {
    try {
      Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((value) async {
        List<Placemark> daftarPlace = await geolocator.placemarkFromCoordinates(
            value.latitude, value.longitude);
        Placemark place = daftarPlace[0];
        setState(() {
          _location = place.locality;
          _latitude = value.latitude.toString();
          _longitude = value.longitude.toString();

          _getData();
        });
      }).catchError((e) {
        debugPrint('error e: $e');
      });
    } catch (error) {
      debugPrint('error try/catch: $error');
    }
  }

  Future _getData() async {
    await ApiUrl.jadwalShalat(ApiUrl.methodMonth, _latitude, _longitude)
        .then((value) => _urlJadwalShalat = value);
    debugPrint('pageShalat: $_urlJadwalShalat');
    ApiService().get(
        url: _urlJadwalShalat,
        headers: {},
        callback: (status, message, response) {
          debugPrint('pageShalat: $status, $message, r: $response');
          setState(() {
            if (_listDatetime.isNotEmpty) _listDatetime.clear();
            if (status) {
              shalat.ResponseShalat resShalat =
                  shalat.ResponseShalat.fromJson(response);
              _listDatetime = resShalat.results.datetime;
            }
          });
          return;
        });
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
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
              expandedHeight: 160,
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
                    onPressed: () => _getCurrenyLocation()),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        Spacer(),
                        Text('Shubuh',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    )
                  ],
                ),
              )),
            ),
          )
        ];
      },
      body: Container(
        margin: EdgeInsets.only(top: _appBarHeight),
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => Container(
                  color: (index % 2 == 0) ? Colors.blue : Colors.red,
                  height: 200,
                  child: Text(
                    'data',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )),
      ),
    )));
  }

  Widget itemShalat(List<String> data, int index) {
    return InkWell();
  }
}
