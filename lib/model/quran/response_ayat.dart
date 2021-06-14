import 'dart:convert';

ResponseAyat responseAyatFromJson(String str) =>
    ResponseAyat.fromJson(json.decode(str));

String responseAyatToJson(ResponseAyat data) => json.encode(data.toJson());

class ResponseAyat {
  ResponseAyat({
    required this.status,
    required this.query,
    required this.bahasa,
    required this.surat,
    required this.ayat,
  });

  String status;
  Query query;
  Bahasa bahasa;
  Surat surat;
  Ayat ayat;

  factory ResponseAyat.fromJson(Map<String, dynamic> json) => ResponseAyat(
        status: json["status"],
        query: Query.fromJson(json["query"]),
        bahasa: Bahasa.fromJson(json["bahasa"]),
        surat: Surat.fromJson(json["surat"]),
        ayat: Ayat.fromJson(json["ayat"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "query": query.toJson(),
        "bahasa": bahasa.toJson(),
        "surat": surat.toJson(),
        "ayat": ayat.toJson(),
      };
}

class Ayat {
  Ayat({
    required this.proses,
    required this.data,
  });

  List<int> proses;
  Data data;

  factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
        proses: List<int>.from(json["proses"].map((x) => x)),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "proses": List<dynamic>.from(proses.map((x) => x)),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.ar,
    required this.idt,
    required this.id,
  });

  List<Ar> ar;
  List<Ar> idt;
  List<Ar> id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ar: List<Ar>.from(json["ar"].map((x) => Ar.fromJson(x))),
        idt: List<Ar>.from(json["idt"].map((x) => Ar.fromJson(x))),
        id: List<Ar>.from(json["id"].map((x) => Ar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ar": List<dynamic>.from(ar.map((x) => x.toJson())),
        "idt": List<dynamic>.from(idt.map((x) => x.toJson())),
        "id": List<dynamic>.from(id.map((x) => x.toJson())),
      };
}

class Ar {
  Ar({
    this.id,
    required this.surat,
    required this.ayat,
    required this.teks,
  });

  Prose? id;
  String surat;
  String ayat;
  String teks;

  factory Ar.fromJson(Map<String, dynamic> json) => Ar(
        id: proseValues.map[json["id"]],
        surat: json["surat"],
        ayat: json["ayat"],
        teks: json["teks"],
      );

  Map<String, dynamic> toJson() => {
        "id": proseValues.reverse[id],
        "surat": surat,
        "ayat": ayat,
        "teks": teks,
      };
}

enum Prose { AR, ID, IDT }

final proseValues =
    EnumValues({"ar": Prose.AR, "id": Prose.ID, "idt": Prose.IDT});

class Bahasa {
  Bahasa({
    required this.proses,
    required this.keterangan,
  });

  List<Prose> proses;
  List<String> keterangan;

  factory Bahasa.fromJson(Map<String, dynamic> json) => Bahasa(
        proses: List<Prose>.from(json["proses"].map((x) => proseValues.map[x])),
        keterangan: List<String>.from(json["keterangan"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "proses": List<dynamic>.from(proses.map((x) => proseValues.reverse[x])),
        "keterangan": List<dynamic>.from(keterangan.map((x) => x)),
      };
}

class Query {
  Query({
    required this.format,
    required this.bahasa,
    required this.bahasa2,
    required this.surat,
    required this.ayat,
    required this.ayat2,
  });

  String format;
  String bahasa;
  List<Prose> bahasa2;
  String surat;
  String ayat;
  List<int> ayat2;

  factory Query.fromJson(Map<String, dynamic> json) => Query(
        format: json["format"],
        bahasa: json["bahasa"],
        bahasa2:
            List<Prose>.from(json["bahasa2"].map((x) => proseValues.map[x])),
        surat: json["surat"],
        ayat: json["ayat"],
        ayat2: List<int>.from(json["ayat2"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "bahasa": bahasa,
        "bahasa2":
            List<dynamic>.from(bahasa2.map((x) => proseValues.reverse[x])),
        "surat": surat,
        "ayat": ayat,
        "ayat2": List<dynamic>.from(ayat2.map((x) => x)),
      };
}

class Surat {
  Surat({
    required this.nomor,
    required this.nama,
    required this.asma,
    required this.name,
    required this.start,
    required this.ayat,
    required this.type,
    required this.urut,
    required this.rukuk,
    required this.arti,
    required this.keterangan,
  });

  String nomor;
  String nama;
  String asma;
  String name;
  String start;
  String ayat;
  String type;
  String urut;
  String rukuk;
  String arti;
  String keterangan;

  factory Surat.fromJson(Map<String, dynamic> json) => Surat(
        nomor: json["nomor"],
        nama: json["nama"],
        asma: json["asma"],
        name: json["name"],
        start: json["start"],
        ayat: json["ayat"],
        type: json["type"],
        urut: json["urut"],
        rukuk: json["rukuk"],
        arti: json["arti"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "nama": nama,
        "asma": asma,
        "name": name,
        "start": start,
        "ayat": ayat,
        "type": type,
        "urut": urut,
        "rukuk": rukuk,
        "arti": arti,
        "keterangan": keterangan,
      };
}

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    // if (reverseMap == null) {
    reverseMap = map.map((k, v) => new MapEntry(v, k));
    // }
    return reverseMap;
  }
}
