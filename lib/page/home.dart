// lib/page/home.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

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
              final rawUrl =
                  (photos != null && photos.isNotEmpty)
                      ? photos[0]['url'] as String
                      : null;
              final isFavorite = _favoriteIndices.contains(index);

              return GFCard(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                boxFit: BoxFit.cover,
                showImage: rawUrl != null,
                elevation: 4,
                color: surface,
                image:
                    rawUrl != null
                        ? Image.network(
                          rawUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (c, e, s) => Container(
                                height: 120,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 40),
                              ),
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
                content: Text(
                  'Season: $seasonStart to $seasonEnd',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.josefinSans(fontSize: 12, color: primary),
                ),
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
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
