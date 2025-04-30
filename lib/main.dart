// lib\main.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

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
        textTheme: GoogleFonts.josefinSansTextTheme(),
        primaryTextTheme: GoogleFonts.josefinSansTextTheme(),
      ),
      home: SurfSpotsGrid(),
    );
  }
}

class SurfSpotsGrid extends StatefulWidget {
  const SurfSpotsGrid({super.key});

  @override
  State<SurfSpotsGrid> createState() => _SurfSpotsGridState();
}

class _SurfSpotsGridState extends State<SurfSpotsGrid> {
  late Future<List<dynamic>> _spotsFuture;

  @override
  void initState() {
    super.initState();
    _spotsFuture = _loadSurfSpots();
  }

  Future<List<dynamic>> _loadSurfSpots() async {
    final jsonString = await rootBundle.loadString('assets/data/records.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    return data['records'] as List<dynamic>;
  }

  String _cleanUrl(String raw) {
    // Remove angle brackets and semicolons
    return raw.replaceAll(RegExp(r'[<>;]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Surf Spots')),
      body: FutureBuilder<List<dynamic>>(
        future: _spotsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          final spots = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final record = spots[index];
              final fields = record['fields'] as Map<String, dynamic>;
              final destination = fields['Destination'] as String;
              final difficulty = fields['Difficulty Level'].toString();
              final seasonStart = fields['Peak Surf Season Begins'] as String;
              final seasonEnd = fields['Peak Surf Season Ends'] as String;
              final photos = fields['Photos'] as List<dynamic>?;
              String imageUrl = '';
              if (photos != null && photos.isNotEmpty) {
                final rawUrl = photos[0]['url'] as String;
                imageUrl = _cleanUrl(rawUrl);
              }

              return GFCard(
                boxFit: BoxFit.cover,
                image: imageUrl.isNotEmpty ? Image.network(imageUrl) : null,
                title: GFListTile(
                  titleText: destination,
                  subTitleText: 'Difficulty: $difficulty',
                ),
                content: Text(
                  'Season: $seasonStart to $seasonEnd',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

