// lib/pages/detail.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import '../services/airtable_api.dart';
import '../utils/position.dart';

class DetailPage extends StatelessWidget {
  final String spotId;
  const DetailPage({super.key, required this.spotId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: AirtableApi().fetchSurfSpotById(spotId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final record = snapshot.data!;
        final fields = record['fields'] as Map<String, dynamic>? ?? {};

        // Parse geocode
        LatLng spotLatLng;
        try {
          spotLatLng = parseLatLng(fields['Geocode'] as String? ?? '');
        } catch (_) {
          spotLatLng = LatLng(0, 0);
        }

        final photoUrl =
            (fields['Photos'] as List<dynamic>?)?.isNotEmpty == true
                ? fields['Photos'][0]['url'] as String
                : 'https://via.placeholder.com/400x300.png?text=No+Image';

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.network(photoUrl, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withAlpha(80)),
              ),
              Positioned(
                bottom: 250,
                left: 16,
                right: 16,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: spotLatLng,
                      initialZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileProvider: CancellableNetworkTileProvider(),
                        maxZoom: 19,
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: spotLatLng,
                            width: 40,
                            height: 40,
                            child: const Icon(
                                  Icons.location_pin,
                                  size: 40,
                                  color: Colors.redAccent,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 32,
                right: 16,
                child: SizedBox(
                  width: 260,
                  child: Card(
                    color: const Color(0xCCA2D8F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fields['Destination'] as String? ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Type: ${(fields['Surf Break'] as List?)?.join(', ') ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Difficulty: ${fields['Difficulty Level'] ?? 'N/A'} / 5',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Season: ${fields['Peak Surf Season Begins']} to ${fields['Peak Surf Season Ends']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          if (fields['Magic Seaweed Link'] != null)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // TODO: use url_launcher to open fields['Magic Seaweed Link']
                              },
                              child: const Text(
                                'View Surf Report',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
