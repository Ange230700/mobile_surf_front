// lib\pages\detail.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../utils/position.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> record;

  const DetailPage({required this.record, super.key});

  @override
  Widget build(BuildContext context) {
    final fields = record['fields'] ?? {};
    final rawGeocode = fields["Geocode"] as String? ?? '';
    LatLng spotLatLng;
    try {
      spotLatLng = parseLatLng(rawGeocode);
    } catch (e) {
      spotLatLng = LatLng(0, 0);
    }
    final String imageUrl =
        (fields['Photos'] != null && fields['Photos'].isNotEmpty)
            ? fields['Photos'][0]['url']
            : 'https://via.placeholder.com/400x300.png?text=No+Image';
    final String destination = fields['Destination'] ?? 'Unknown Spot';
    final String surfBreak =
        (fields['Surf Break'] != null && fields['Surf Break'].isNotEmpty)
            ? (fields['Surf Break'] as List).join(', ')
            : 'Unknown Type';
    final int? difficulty = fields['Difficulty Level'];
    final String seasonStart = fields['Peak Surf Season Begins'] ?? '';
    final String seasonEnd = fields['Peak Surf Season Ends'] ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(''),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(color: Colors.black.withAlpha(77)),
          ),
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: spotLatLng,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
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
            bottom: 400,
            right: 0,
            left: 0,
            child: SizedBox(
              width: 250,
              child: Card(
                color: const Color(0xCCA2D8F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination,
                        style: const TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Type: $surfBreak',
                        style: const TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Difficulty: ${difficulty?.toString() ?? 'N/A'} / 5',
                        style: const TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Season: $seasonStart to $seasonEnd',
                        style: const TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final url = fields['Magic Seaweed Link'];
                          if (url != null) {
                            // You can use url_launcher here to open the link if needed
                          }
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
  }
}
