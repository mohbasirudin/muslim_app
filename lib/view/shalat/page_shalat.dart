import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:quran/api/api_service.dart';
import 'package:quran/api/api_url.dart';
import 'package:quran/baseurl/base_app.dart';
import 'package:quran/helper/remove_glow.dart';
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
  var _location = '',
      _latitude = '',
      _longitude = '',
      _urlJadwalShalat = '',
      _today = '--:--',
      _shubuh = '--:--',
      _dhuhur = '--:--',
      _ashar = '--:--',
      _maghrib = '--:--',
      _isya = '--:--',
      _statusShubuh = false,
      _statusDhuhur = false,
      _statusAshar = false,
      _statusMaghrib = false,
      _statusIsya = false;
  List<shalat.Datetime> _listDatetime = List();
  var _statusBarHeight = 0.0, _appBarHeight = 0.0;
  var _pageLoading = true;
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
    ApiService().get(
        url: _urlJadwalShalat,
        headers: {},
        callback: (status, message, response) {
          setState(() {
            if (_listDatetime.isNotEmpty) _listDatetime.clear();
            if (status) {
              shalat.ResponseShalat resShalat =
                  shalat.ResponseShalat.fromJson(response);
              _listDatetime = resShalat.results.datetime;

              for (var i = 0; i < _listDatetime.length; i++)
                if (_listDatetime[i].date.gregorian == _today) {
                  setState(() {
                    _shubuh = _listDatetime[i].times.fajr;
                    _dhuhur = _listDatetime[i].times.dhuhr;
                    _ashar = _listDatetime[i].times.asr;
                    _maghrib = _listDatetime[i].times.maghrib;
                    _isya = _listDatetime[i].times.isha;

                    var _curTime = Func.timeToInt(Func.getTime(Format.time_3));
                    var _iShubuh = Func.timeToInt(_shubuh);
                    var _iDhuhur = Func.timeToInt(_dhuhur);
                    var _iAshar = Func.timeToInt(_ashar);
                    var _iMaghrib = Func.timeToInt(_maghrib);
                    var _iIsya = Func.timeToInt(_isya);

                    if (_curTime >= _iShubuh && _curTime < _iDhuhur)
                      _statusDhuhur = true;
                    else if (_curTime >= _iDhuhur && _curTime < _iAshar)
                      _statusAshar = true;
                    else if (_curTime >= _iAshar && _curTime < _iMaghrib)
                      _statusMaghrib = true;
                    else if (_curTime >= _iMaghrib && _curTime < _iIsya)
                      _statusIsya = true;
                    else
                      _statusShubuh = true;
                  });
                }
            }
            _pageLoading = false;
          });
          return;
        });
  }

  @override
  Widget build(BuildContext context) {
    _statusBarHeight = MediaQuery.of(context).padding.top;
    _appBarHeight = AppBar().preferredSize.height;
    _today = Func.getTime(Format.time_4);

    return MaterialApp(
      debugShowCheckedModeBanner: Status.debug,
        color: Colors.white,
        home: Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: (context, scrolling) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.teal,
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
                        onPressed: () {
                          _pageLoading = true;
                          _getCurrenyLocation();
                        }),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                    padding: EdgeInsets.only(
                        top: _statusBarHeight + _appBarHeight + Size.size16,
                        left: Size.size16,
                        right: Size.size16),
                    color: Colors.teal[700],
                    child: Column(
                      children: [
                        _itemToday(Time.shubuh, _shubuh, _statusShubuh),
                        _itemToday(Time.dhuhur, _dhuhur, _statusDhuhur),
                        _itemToday(Time.ashar, _ashar, _statusAshar),
                        _itemToday(Time.maghrib, _maghrib, _statusMaghrib),
                        _itemToday(Time.isya, _isya, _statusIsya),
                      ],
                    ),
                  )),
                ),
              )
            ];
          },
          body: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: _appBarHeight),
                child: ScrollConfiguration(
                  behavior: RemoveGlow(),
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _listDatetime.length,
                      itemBuilder: (context, index) =>
                          _itemShalat(_listDatetime, index)),
                ),
              ),
              Center(
                child: Visibility(
                  visible: _pageLoading,
                  child: JumpingDotsProgressIndicator(
                    fontSize: Size.size40,
                    color: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  _itemShalat(List<shalat.Datetime> listDatetime, var index) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: (index == 0)
            ? EdgeInsets.all(Size.size4)
            : EdgeInsets.only(
                left: Size.size4, right: Size.size4, bottom: Size.size4),
        child: Card(
          elevation: 4,
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: Size.size8, horizontal: Size.size4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: Size.size8, horizontal: Size.size16),
                  child: Row(
                    children: [
                      Text(
                        _listDatetime[index].date.gregorian,
                        style: TextStyle(
                            fontSize: Size.size14,
                            color:
                                (_listDatetime[index].date.gregorian == _today)
                                    ? Colors.teal
                                    : Colors.black),
                      ),
                      Spacer(),
                      Visibility(
                        visible: (_listDatetime[index].date.gregorian == _today)
                            ? true
                            : false,
                        child: Text(
                          'Hari ini',
                          style: TextStyle(
                              fontSize: Size.size14, color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: Size.size8),
                  child: Divider(
                    height: 1,
                    color: Colors.grey[500],
                  ),
                ),
                Row(
                  children: [
                    _itemWaktu(Time.shubuh, listDatetime[index].times.fajr),
                    _itemWaktu(Time.dhuhur, listDatetime[index].times.dhuhr),
                    _itemWaktu(Time.ashar, listDatetime[index].times.asr),
                    _itemWaktu(Time.maghrib, listDatetime[index].times.maghrib),
                    _itemWaktu(Time.isya, listDatetime[index].times.isha),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _itemWaktu(var waktuShalat, var jamShalat) {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              waktuShalat,
              style: TextStyle(fontSize: Size.size12, color: Colors.black),
            ),
            Text(
              jamShalat,
              style: TextStyle(
                  fontSize: Size.size16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  _itemToday(var shalat, var time, var status) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Size.size4),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: Size.size16),
            child: Icon(
              Icons.access_time,
              color: (status) ? Colors.white : Colors.white70,
              size: Size.size16,
            ),
          ),
          Text(shalat,
              style: TextStyle(
                  color: (status) ? Colors.white : Colors.white70,
                  fontSize: Size.size16)),
          Spacer(),
          Text(time,
              style: TextStyle(
                  color: (status) ? Colors.white : Colors.white70,
                  fontSize: Size.size16)),
        ],
      ),
    );
  }
}
