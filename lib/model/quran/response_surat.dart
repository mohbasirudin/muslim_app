class ResponseSurat {
  late String status;
  late Query? query;
  late List<Hasil> hasil;

  ResponseSurat({required this.status, this.query, required this.hasil});

  ResponseSurat.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
    if (json['hasil'] != null) {
      hasil = <Hasil>[];
      json['hasil'].forEach((v) {
        hasil.add(new Hasil.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.query != null) {
      data['query'] = this.query!.toJson();
    }
    if (this.hasil != null) {
      data['hasil'] = this.hasil.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Query {
  late String format;
  late String surat;
  Query({required this.format, required this.surat});

  Query.fromJson(Map<String, dynamic> json) {
    format = json['format'];
    surat = json['surat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['format'] = this.format;
    data['surat'] = this.surat;
    return data;
  }
}

class Hasil {
  late String nomor;
  late String nama;
  late String asma;
  late String name;
  late String start;
  late String ayat;
  late String type;
  late String urut;
  late String rukuk;
  late String arti;
  late String keterangan;

  Hasil(
      {required this.nomor,
      required this.nama,
      required this.asma,
      required this.name,
      required this.start,
      required this.ayat,
      required this.type,
      required this.urut,
      required this.rukuk,
      required this.arti,
      required this.keterangan});

  Hasil.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    nama = json['nama'];
    asma = json['asma'];
    name = json['name'];
    start = json['start'];
    ayat = json['ayat'];
    type = json['type'];
    urut = json['urut'];
    rukuk = json['rukuk'];
    arti = json['arti'];
    keterangan = json['keterangan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomor'] = this.nomor;
    data['nama'] = this.nama;
    data['asma'] = this.asma;
    data['name'] = this.name;
    data['start'] = this.start;
    data['ayat'] = this.ayat;
    data['type'] = this.type;
    data['urut'] = this.urut;
    data['rukuk'] = this.rukuk;
    data['arti'] = this.arti;
    data['keterangan'] = this.keterangan;
    return data;
  }
}
