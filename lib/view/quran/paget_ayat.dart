import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:quran/api/api_service.dart';
import 'package:quran/api/api_url.dart';
import 'package:quran/baseurl/base_app.dart' as BaseApp;
import 'package:quran/helper/remove_glow.dart';
import 'package:quran/model/quran/response_ayat.dart';
import 'package:quran/baseurl/base_app.dart';
import 'package:quran/view/page_main.dart';

class PageAyat extends StatefulWidget {
  final Map<String, dynamic> data;
  const PageAyat({Key key, this.data}) : super(key: key);

  @override
  _PageAyatState createState() => _PageAyatState();
}

class _PageAyatState extends State<PageAyat> {
  var _data;
  var _url = '', _totalAyat = '', _suratNama = '';
  var _ayatStart = 1, _ayatEnd = 10;
  var _isLoading = false, _pageLoading = true;
  List<Ar> _listArab = new List(), _listIndo = new List();

  @override
  void initState() {
    _data = widget.data;
    _totalAyat = _data[BaseApp.Data.totalAyat];
    _suratNama = _data[BaseApp.Data.suratNama];
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            _suratNama,
            style: TextStyle(fontSize: Size.size16, color: Colors.white),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => PageMain()))),
        ),
        body: Stack(
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
            Column(
              children: <Widget>[
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollNotification) {
                      if (!_isLoading &&
                          scrollNotification.metrics.pixels ==
                              scrollNotification.metrics.maxScrollExtent) {
                        if (_listArab.length < int.parse(_totalAyat)) {
                          getData();
                          setState(() {
                            _isLoading = true;
                            _ayatStart = _ayatEnd + 1;
                            _ayatEnd = _ayatEnd + 10;
                          });
                        }
                      }
                      return true;
                    },
                    child: ScrollConfiguration(
                      behavior: RemoveGlow(),
                      child: ListView.builder(
                        itemCount: _listArab.length,
                        itemBuilder: (context, index) =>
                            itemAyat(_listArab, _listIndo, index),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isLoading,
                  child: Container(
                    height: 48,
                    color: Colors.transparent,
                    child: Center(
                      child: JumpingDotsProgressIndicator(
                        fontSize: Size.size40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future getData() async {
    await ApiUrl.ayatRange(_data[BaseApp.Data.suratID], _ayatStart, _ayatEnd)
        .then((value) => _url = value);
    debugPrint('$_ayatStart, $_ayatEnd');

    ApiService().get(
        url: _url,
        callback: (status, message, response) {
          setState(() {
            if (status) {
              ResponseAyat resAyat =
                  ResponseAyat.fromJson(jsonDecode(json.encode(response)));
              _listArab.addAll(resAyat.ayat.data.ar);
              _listIndo.addAll(resAyat.ayat.data.id);
              _isLoading = false;
              _pageLoading = false;
            } else {
              debugPrint('pageMain Gagal: $status, $message, $response');
            }
          });
        });
  }

  Widget itemAyat(List<Ar> listArab, List<Ar> listIndo, var index) {
    return InkWell(
      hoverColor: Colors.blue,
      onTap: () {
        debugPrint('$index');
      },
      child: Ink(
        color: (index % 2 == 1) ? Colors.white : Colors.grey[50],
        child: Container(
          margin: EdgeInsets.all(Size.size16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                Func.convertUtf8(listArab[index].teks),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: Size.size16,
                  color: Colors.blue,
                ),
              ),
              Text(
                listIndo[index].teks,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: Size.size16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
