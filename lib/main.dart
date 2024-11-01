import 'package:flutter/material.dart';
import 'package:hashmicro_attendance/services/location_service.dart';
import 'package:hashmicro_attendance/views/home_view.dart';
import 'package:hashmicro_attendance/widgets/warna.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocationService().initializeService();
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
      theme: ThemeData(
        primaryColor: Warna.merah,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
