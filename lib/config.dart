import 'dart:convert';
import 'dart:developer';

import 'package:hashmicro_attendance/models/attendance_model.dart';
import 'package:hashmicro_attendance/models/office_location_model.dart';
import 'package:hashmicro_attendance/models/user_current_location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static String logo = 'assets/hashmicro_logo.png';

  static OfficeLocation officeLocation = OfficeLocation.fromJson({
    "id": 0,
    "nama_lokasi": 'HashMicro Office', // 'HashMicro Office',
    "lat": -6.170493460271974, //-6.86041394476131, // -6.170493460271974,
    "lang": 106.81334476558658, //107.60631980983976,// 106.81334476558658,
    "jarak": 50,
  });

  static UserCurrentLocation userLocation = UserCurrentLocation.fromJson({
    "name": "Ahmad Hammam Muhajir Hanan",
    "lat": 0.0,
    "long": 0.0,
  });
}

class DataManager {
  Future<void> setDataAttendance(AttendanceItem data) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // Konversi List<AttendanceItem> ke List<Map<String, dynamic>> lalu ke JSON string
    String jsonString = jsonEncode(data);
    await pref.setString('data_attendance', jsonString);
  }

   Future<void> setDataListAttendance(List<AttendanceItem> data) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // Konversi List<AttendanceItem> ke List<Map<String, dynamic>> lalu ke JSON string
    String jsonString = jsonEncode(data.map((item) => item.toJson()).toList());
    await pref.setString('data_attendance', jsonString);
  }

  Future<List<AttendanceItem>> getDataAttendance() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonString = pref.getString('data_attendance');

    // Jika ada data, decode JSON string ke List<AttendanceItem>
    if (jsonString != null && jsonString.isNotEmpty) {
      log(jsonString);
      List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((item) => AttendanceItem.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  Future<void> setUserLocation(UserCurrentLocation data) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // Konversi List<AttendanceItem> ke List<Map<String, dynamic>> lalu ke JSON string
    String jsonString = jsonEncode(data);
    await pref.setString('user_location', jsonString);
  }

  Future<UserCurrentLocation> getUserLocation() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonString = pref.getString('user_location');

    // Jika ada data, decode JSON string ke List<AttendanceItem>
    if (jsonString != null && jsonString.isNotEmpty) {
      log(jsonString);
      dynamic jsonData = jsonDecode(jsonString);
      return UserCurrentLocation.fromJson(jsonData);
    } else {
      return UserCurrentLocation.fromJson({
        "name": "Ahmad Hammam Muhajir Hanan",
        "lat": 0.0,
        "long": 0.0,
      });
    }
  }
}

class DataHelper {
  DataManager dataMr = DataManager();

  // Simpan data
  Future<void> setData(AttendanceItem data) async {
    await dataMr.setDataAttendance(data);
  }

  Future<void> setDataList(List<AttendanceItem> data) async {
    await dataMr.setDataListAttendance(data);
  }

  // Ambil data
  Future<List<AttendanceItem>> getData() async {
    return await dataMr.getDataAttendance();
  }

  // Update data attendance berdasarkan ID
  Future<void> updateData(AttendanceItem updatedData) async {
    // Ambil data kehadiran saat ini
    List<AttendanceItem> currentDataList = await getData();

    // Cari data yang memiliki ID yang sama dan update
    for (int i = 0; i < currentDataList.length; i++) {
      if (currentDataList[i].id == updatedData.id) {
        currentDataList[i] = updatedData;
        break;
      }
    }

    // Simpan daftar data yang sudah diperbarui
    await setDataList(currentDataList);
  }
}

class DataAttendance {
  static List<AttendanceItem> listAttendance = [
    AttendanceItem.fromJson({
      'id': 0,
      'name': 'Ahmad Hammmam Muhajir Hanan',
      'checkin_at': '',
      'checkout_at': '',
    })
  ];
}
