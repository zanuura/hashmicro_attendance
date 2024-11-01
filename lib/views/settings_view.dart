import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hashmicro_attendance/config.dart';
import 'package:hashmicro_attendance/models/office_location_model.dart';
import 'package:hashmicro_attendance/widgets/custom_textfield.dart';
import 'package:hashmicro_attendance/widgets/warna.dart';
import 'package:toast/toast.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  TextEditingController officeNameController = TextEditingController();
  TextEditingController officeLatitudeController = TextEditingController();
  TextEditingController officeLongitudeController = TextEditingController();
  TextEditingController distanceContoller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    setState(() {
      officeNameController.text = AppConfig.officeLocation.namaLokasi!;
      officeLatitudeController.text = AppConfig.officeLocation.lat.toString();
      officeLongitudeController.text = AppConfig.officeLocation.lang.toString();
      distanceContoller.text = '${AppConfig.officeLocation.jarak} meter';
    });
  }

  void updateData() {
    setState(() {
      AppConfig.officeLocation = OfficeLocation.fromJson({
        "id": 0,
        "nama_lokasi": officeNameController.text, // 'HashMicro Office',
        "lat":
            double.parse(officeLatitudeController.text), // -6.170493460271974,
        "lang":
            double.parse(officeLongitudeController.text), // 106.81334476558658,
        "jarak": int.parse(distanceContoller.text),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Warna.merah.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Warna.merah, width: 1.5),
              ),
              child: Center(
                child: Text(
                  'Tekan Kirim / enter setelah melakukan perubahan !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Warna.merah,
                  ),
                ),
              ),
            ),
            CTextField(
              controller: officeNameController,
              labelText: 'Nama Lokasi',
              hintText: 'HashMicro Office',
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              onChanged: (p0) {
                // distanceContoller.text = '$p0 meter';
              },
              onSubmitted: (p0) {
                setState(() {
                  AppConfig.officeLocation.namaLokasi = p0;
                  log(AppConfig.officeLocation.namaLokasi!);
                });
              },
            ),
            CTextField(
              controller: officeLatitudeController,
              labelText: 'Latitude Lokasi',
              hintText: '0.00',
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              onChanged: (p0) {
                // distanceContoller.text = '$p0 meter';
              },
              onSubmitted: (p0) {
                setState(() {
                  AppConfig.officeLocation.lat = double.parse(p0);
                  log(AppConfig.officeLocation.lat.toString());
                });
              },
            ),
            CTextField(
              controller: officeLongitudeController,
              labelText: 'Longitude Lokasi',
              hintText: '0.00',
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              onChanged: (p0) {
                // distanceContoller.text = '$p0 meter';
              },
              onSubmitted: (p0) {
                setState(() {
                  AppConfig.officeLocation.lang = double.parse(p0);
                  log(AppConfig.officeLocation.lang.toString());
                });
              },
            ),
            CTextField(
              controller: distanceContoller,
              labelText: 'Maksimal Jarak Check-in | Meter',
              hintText: '50 meter',
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.number,
              onChanged: (p0) {
//                 setState(() {
//   distanceContoller.text = '$p0 meter';
// });
              },
              onSubmitted: (p0) {
                setState(() {
                  AppConfig.officeLocation.jarak = int.parse(p0);
                  log(AppConfig.officeLocation.jarak.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
