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

class SurfSpotsGrid extends StatefulWidget {
  const SurfSpotsGrid({super.key});

  @override
  State<SurfSpotsGrid> createState() => _SurfSpotsGridState();
}

class _SurfSpotsGridState extends State<SurfSpotsGrid> {
  late Future<List<dynamic>> _spotsFuture;

  final Set<int> _favoriteIndices = {};

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final surface = theme.colorScheme.surface;

    return Scaffold(
      appBar: AppBar(title: const Text('Surf Spots')),
      body: FutureBuilder<List<dynamic>>(
        future: _spotsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
              final rawUrl = photos != null && photos.isNotEmpty
                ? photos[0]['url'] as String
                : null;
              final imageUrl = rawUrl;
              final isFavorite = _favoriteIndices.contains(index);

              return GFCard(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                boxFit: BoxFit.cover,
                showImage: imageUrl != null,
                color: surface,
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                buttonBar: GFButtonBar(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      color: isFavorite ? primary : secondary,
                      onPressed: () {
                        setState(() {
                          if (isFavorite) {
                            _favoriteIndices.remove(index);
                          } else {
                            _favoriteIndices.add(index);
                          }
                        });
                      }
                    ),
                  ],
                ),
                image: imageUrl != null
                  ? Image.network(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 40),
                      );
                    },
                  )
                  : null,
                title: GFListTile(
                  title: Text(
                    destination,
                    style: GoogleFonts.josefinSans(
                      color: primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subTitle: Text(
                    'Difficulty: $difficulty',
                    style: GoogleFonts.josefinSans(
                      color: secondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                content: Flexible(
                  child: Text(
                    'Season: $seasonStart to $seasonEnd',
                    style: GoogleFonts.josefinSans(fontSize: 12, color: primary),
                    softWrap: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

