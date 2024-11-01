class UserCurrentLocation {
  String? name;
  double? lat;
  double? long;

  UserCurrentLocation({this.name, this.lat, this.long});

  UserCurrentLocation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}
