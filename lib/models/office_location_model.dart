
class OfficeLocation {
  int? id;
  String? namaLokasi;
  double? lat;
  double? lang;
  int? jarak;

  OfficeLocation({this.id, this.namaLokasi, this.lat, this.lang, this.jarak});

  OfficeLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaLokasi = json['nama_lokasi'];
    lat = (json['lat'] != null) ? json['lat'] : null;
    lang = (json['lang'] != null) ? json['lang'] : null;
    jarak = json['jarak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_lokasi'] = namaLokasi;
    data['lat'] = lat;
    data['lang'] = lang;
    data['jarak'] = jarak;
    return data;
  }
}

