import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hashmicro_attendance/config.dart';
import 'package:hashmicro_attendance/models/user_current_location_model.dart';
import 'package:hashmicro_attendance/widgets/warna.dart';
import 'package:latlong2/latlong.dart';
import 'package:uicons/uicons.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key,});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  UserCurrentLocation userPosition = UserCurrentLocation.fromJson({});
  @override
  void initState() {
    super.initState();
    getUserPosition();
    log(AppConfig.officeLocation.namaLokasi.toString());
  }

  void getUserPosition() async {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      UserCurrentLocation position = await DataManager().getUserLocation();
      setState(() {
        userPosition = position;
        log("User location: ${userPosition.lat}, ${userPosition.long}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            AppConfig.officeLocation.lat!,
            AppConfig.officeLocation.lang!,
          ), // Koordinat default
          initialZoom: 20.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: [
            Marker(
              point: LatLng(
                AppConfig.officeLocation.lat!,
                AppConfig.officeLocation.lang!,
              ),
              child: InkWell(
                onTap: () {},
                child: Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Warna.merah,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    // Icons.location_city_rounded,
                    UIcons.solidRounded.building,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            Marker(
              point: userPosition.lat == null
                  ? LatLng(
                      AppConfig.officeLocation.lat!,
                      AppConfig.officeLocation.lang!,
                    )
                  : LatLng(
                      userPosition.lat!,
                      userPosition.long!,
                    ),
              child: InkWell(
                onTap: () {},
                child: Icon(
                  // Icons.location_city_rounded,
                  UIcons.solidRounded.marker,
                  color: Warna.merah,
                  size: 20,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
