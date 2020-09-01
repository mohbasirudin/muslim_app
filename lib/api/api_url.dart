import 'package:quran/model/shalat/response_shalat.dart';

class ApiUrl {
  static const baseUrl = 'https://api.banghasan.com';
  static const surat = '$baseUrl/quran/format/json/surat';
  static const apiAladhan = 'http://api.aladhan.com/v1/calendar';

  static Future<String> ayatRange(var nomor, var start, var end) async {
    return '$baseUrl/quran/format/json/surat/$nomor/ayat/$start-$end';
  }

  static Future<String> jadwalShalat(
      var latitude, var longitude, var method, var month, var year) async {
    return '$apiAladhan?latitude=$latitude&longitude=$longitude&method=$method&month=$month&year=$year';
  }
}
