import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quran/api/api_service.dart';
import 'package:quran/api/api_url.dart';
import 'package:quran/baseurl/base_asset.dart';
import 'package:quran/baseurl/base_style.dart';
import 'package:quran/helper/remove_glow.dart';
import 'package:quran/model/quran/response_surat.dart';
import 'package:quran/baseurl/base_app.dart';
import 'package:quran/view/quran/paget_ayat.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran/view/shalat/page_shalat.dart';

class PageMain extends StatefulWidget {
  @override
  _PageMainState createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  RefreshController _refreshCon = RefreshController();
  var _pageLoading = true;
  var _curLocation = '', _latitude = '', _longitude = '';
  var _appBarHeight = 0.0, _statusBarHeight = 0.0;

  final ApiService _apiService = ApiService();
  List<Hasil> listHasil = List();

  @override
  void initState() {
    _getCurrenyLocation();
    _getData();
    super.initState();
  }

  Future _getData() async {
    _refreshCon.refreshToIdle();
    await _apiService.get(
        url: ApiUrl.surat,
        headers: {},
        callback: (status, message, response) {
          setState(() {
            _refreshCon.refreshCompleted();
            _pageLoading = false;

            if (listHasil.isNotEmpty) listHasil.clear();
            if (status) {
              ResponseSurat resSurat = ResponseSurat.fromJson(response);
              listHasil = resSurat.hasil;
            }
          });
          return;
        });
  }

  Future _getCurrenyLocation() async {
    try {
      Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((value) async {
        _latitude = value.latitude.toString();
        _longitude = value.longitude.toString();
        List<Placemark> daftarPlace = await geolocator.placemarkFromCoordinates(
            value.latitude, value.longitude);
        Placemark place = daftarPlace[0];
        setState(() {
          _curLocation = place.locality;
        });
      }).catchError((e) {
        debugPrint('error e: $e');
      });
    } catch (error) {
      debugPrint('error try/catch: $error');
    }
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
                expandedHeight: 160,
                forceElevated: scrolling,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding:
                        EdgeInsets.only(top: _appBarHeight + _statusBarHeight),
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          margin: EdgeInsets.only(top: _appBarHeight),
          child: Stack(
            children: [
              Center(
                child: Visibility(
                  visible: _pageLoading,
                  child: JumpingDotsProgressIndicator(
                    fontSize: Size.size40,
                    color: Colors.blue,
                  ),
                ),
              ),
              SmartRefresher(
                controller: _refreshCon,
                enablePullUp: true,
                onRefresh: _getData,
                child: ListView.builder(
                  itemCount: listHasil.length,
                  itemBuilder: (context, index) => itemSurat(listHasil, index),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget itemSurat(List<Hasil> listHasil, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          Map<String, dynamic> data = {
            Data.suratID: (index + 1).toString(),
            Data.totalAyat: listHasil[index].ayat,
            Data.suratNama: listHasil[index].nama
          };
          return PageAyat(data: data);
        }));
      },
      child: Container(
        margin: EdgeInsets.all(Size.size16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                styleText(listHasil[index].nama, Size.size16, Colors.black,
                    FontWeight.normal, 1, null),
                styleText(
                    listHasil[index].arti +
                        ' | ' +
                        listHasil[index].ayat +
                        ' ayat',
                    Size.size12,
                    Colors.grey,
                    FontWeight.normal,
                    2,
                    null),
              ],
            ),
            Spacer(),
            Container(
              height: Size.size40,
              child: Image.asset(BaseAsset.imagesSurat[index]),
            )
          ],
        ),
      ),
    );
  }
}
