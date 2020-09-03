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

class Time {
  static String shubuh = 'Shubuh';
  static String dhuhur = 'Dhuhur';
  static String ashar = 'Ashar';
  static String maghrib = 'Maghrib';
  static String isya = 'Isya';
}

class Format {
  static String time_1 = 'dd MMM yyyy';
  static String time_2 = 'dd MMMM yyyy';
  static String time_3 = 'HH:mm';
}

class Func {
  static String convertUtf8(String data) {
    var varData = data.codeUnits;
    return utf8.decode(varData);
  }

  static String getTime(var format) {
    var date = DateTime.now();
    var f = DateFormat(format);
    return f.format(date);
  }

  static int timeToInt(String time) {
    List<String> listData = time.split(':');
    return (int.parse(listData[0]) * 60) + int.parse(listData[1]);
  }
}
