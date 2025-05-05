// lib\main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surf Spots',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0E5386),
          secondary: Color(0xFFA2D8F7),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0E5386),
          foregroundColor: Colors.white,
        ),
        textTheme: GoogleFonts.josefinSansTextTheme(),
        primaryTextTheme: GoogleFonts.josefinSansTextTheme(),
      ),
      home: SurfSpotsGrid(),
    );
  }
}
