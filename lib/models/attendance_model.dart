class AttendanceData {
  List<AttendanceItem>? data;

  AttendanceData({this.data});

  AttendanceData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AttendanceItem>[];
      json['data'].forEach((v) {
        data!.add( AttendanceItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class AttendanceItem {
  int? id;
  String? name;
  String? checkinAt;
  String? checkoutAt;

  AttendanceItem({this.id, this.name, this.checkinAt, this.checkoutAt});

  AttendanceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    checkinAt = json['checkin_at'];
    checkoutAt = json['checkout_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['checkin_at'] = this.checkinAt;
    data['checkout_at'] = this.checkoutAt;
    return data;
  }
}
