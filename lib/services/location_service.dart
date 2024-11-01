import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hashmicro_attendance/config.dart';

class LocationService {
  void initializeService() async {
    final service = FlutterBackgroundService();

    await _checkAndRequestPermission();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart, // Pastikan `onStart` berada di tingkat atas
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    log('starting location service');

    await service.startService();
  }

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }
}

// Fungsi `onStart` diubah menjadi fungsi tingkat atas
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  getUserPosition();
}

Future<void> getUserPosition() async {
  DataManager dataMr = DataManager();

  Timer.periodic(const Duration(seconds: 3), (timer) async {
    Position? position = await _determinePosition();
    AppConfig.userLocation.lat = position.latitude;
    AppConfig.userLocation.long = position.longitude;
    await dataMr.setUserLocation(AppConfig.userLocation);
    log("Background location: ${AppConfig.userLocation.lat}, ${AppConfig.userLocation.long}");
  });
}

Future<void> _checkAndRequestPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied || 
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied || 
      permission == LocationPermission.deniedForever) {
    throw Exception("Location permissions are denied");
  }

  getUserPosition();
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location Service are disabled');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location Permission Denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location Permission Are Permanently Denied');
  }

  return await Geolocator.getCurrentPosition();
}
