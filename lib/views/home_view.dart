import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hashmicro_attendance/config.dart';
import 'package:hashmicro_attendance/models/attendance_model.dart';
import 'package:hashmicro_attendance/models/office_location_model.dart';
import 'package:hashmicro_attendance/models/user_current_location_model.dart';
import 'package:hashmicro_attendance/views/settings_view.dart';
import 'package:hashmicro_attendance/widgets/custom_toast.dart';
import 'package:hashmicro_attendance/widgets/map_widget.dart';
import 'package:hashmicro_attendance/widgets/warna.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserCurrentLocation userPosition = UserCurrentLocation.fromJson({});
  List<AttendanceItem> listAttend = [];
  AttendanceItem newAttend = AttendanceItem.fromJson({});
  @override
  void initState() {
    super.initState();
    getUserPosition();
    getDataListAttend();
    log(AppConfig.officeLocation.namaLokasi.toString());
  }

  void getUserPosition() async {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      userPosition = await DataManager().getUserLocation();
      log("User location: ${userPosition.lat}, ${userPosition.long}");
    });
  }

  Future<void> getDataListAttend() async {
    // DataHelper().setDataList(DataAttendance.listAttendance);
    List<AttendanceItem> list = await DataHelper().getData();
    setState(() {
      listAttend = list;
    });
  }

  void checkIn() async {
    await getDataListAttend();
    bool isWithinRange = await checkUserOfficeDistance();
    if (!isWithinRange) {
      showToast('User terlalu jauh dari kantor untuk check-in.');
      return;
    }
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Cek apakah user sudah check-in hari ini
    AttendanceItem? todayAttendance = listAttend.firstWhere(
      (attend) => attend.checkinAt!.startsWith(todayDate),
      orElse: () =>
          AttendanceItem(id: null, name: '', checkinAt: '', checkoutAt: ''),
    );

    // if (todayAttendance.checkinAt!.isNotEmpty) {
    //   showToast('Anda sudah check-in hari ini.');
    //   return;
    // }
    // Menambahkan data baru untuk hari ini
    int newId = listAttend.isEmpty
        ? 1
        : listAttend.map((e) => e.id).reduce((a, b) => a! > b! ? a : b)! + 1;
    String time = DateTime.now().toString();
    log(time);
    setState(() {
      newAttend = AttendanceItem.fromJson({
        "id": newId,
        "name": 'Ahmad Hammam Muhajir Hanan',
        'checkin_at': time,
        'checkout_at': '',
      });
      listAttend.add(newAttend);
    });
    await DataHelper().setDataList(listAttend);
    showToast('Berhasil Check-in pada $time');
    // await getDataListAttend();
  }

  void checkOut() async {
    await getDataListAttend();
    bool isWithinRange = await checkUserOfficeDistance();
    if (!isWithinRange) {
      showToast('User terlalu jauh dari kantor untuk check-out.');
      return;
    }
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Cari data attendance hari ini
    AttendanceItem? todayAttendance = listAttend.firstWhere(
      (attend) =>
          attend.checkinAt!.startsWith(todayDate) && attend.checkoutAt!.isEmpty,
      orElse: () =>
          AttendanceItem(id: null, name: '', checkinAt: '', checkoutAt: ''),
    );

    if (todayAttendance.checkinAt!.isEmpty) {
      showToast('Anda belum check-in hari ini.');
      return;
    }
    String time = DateTime.now().toString();
    log(time);
    newAttend = AttendanceItem.fromJson({
      "id": todayAttendance.id,
      'name': todayAttendance.name,
      'checkin_at': todayAttendance.checkinAt,
      'checkout_at': time,
    });
    await DataHelper().updateData(newAttend);
    showToast('Check-out berhasil pada $time.');
    await getDataListAttend();
  }

  Future<bool> checkUserOfficeDistance() async {
    OfficeLocation officeLocation = AppConfig.officeLocation;
    Position userPosition = await Geolocator.getCurrentPosition();

    double distance = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      officeLocation.lat!,
      officeLocation.lang!,
    );

    log('Jarak user ke kantor: $distance meter');
    return distance <=
        AppConfig.officeLocation.jarak!; // True jika dalam jarak 50 meter
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 10,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  AppConfig.logo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'HashMicro Attendance',
              style: TextStyle(
                color: Warna.merah,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsView(),
                  )).then((v) {
                getDataListAttend();
              });
            },
            child: Icon(
              UIcons.solidRounded.settings,
              size: 25,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: const MapWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          checkIn();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Warna.merah,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Check In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          checkOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Warna.merah, width: 1.5),
                          ),
                        ),
                        child: Text(
                          'Check Out',
                          style: TextStyle(color: Warna.merah),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: listAttend.length,
              shrinkWrap: true,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(listAttend[index].name.toString()),
                  subtitle: Text(
                      "To ${AppConfig.officeLocation.namaLokasi}\nCheckin at ${listAttend[index].checkinAt} | Chekcout at ${listAttend[index].checkoutAt}"),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
