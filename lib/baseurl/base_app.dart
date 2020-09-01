import 'dart:convert';
import 'package:intl/intl.dart';

class Size {
  static double size8 = 8.0;
  static double size12 = 12.0;
  static double size14 = 14.0;
  static double size16 = 16.0;
  static double size18 = 18.0;
  static double size20 = 20.0;
  static double size24 = 24.0;
  static double size32 = 32.0;
  static double size40 = 40.0;
  static double size64 = 64.0;
}

class Data {
  static String suratID = 'suratID';
  static String totalAyat = 'ayat';
  static String suratNama = 'nama';
}

class Format {
  static String time_1 = 'dd MMM yyyy';
}

class Func {
  static String convertUtf8(String data) {
    var varData = data.codeUnits;
    return utf8.decode(varData);
  }

  static String getTime(var format) {
    // var date = DateTime.now().toString();
    // var dateParse = DateTime.parse(date);
    // var data = dateParse.day.toString()+'-'+dateParse.month.toString()+'-'+dateParse.year.toString();
    // return data;
    var date = DateTime.now();
    var f = DateFormat(format);
    return f.format(date);
  }
}
