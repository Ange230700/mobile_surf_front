// lib/pages/detail.dart

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/surfspot_api.dart';
import '../models/surf_spot.dart';

class DetailPage extends StatelessWidget {
  final String spotId;
  final _api = SurfSpotApi();

  DetailPage({super.key, required this.spotId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SurfSpot>(
      future: _api.fetchSurfSpotById(spotId),
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

        final spot = snapshot.data!;

        // Parse geocode
        final LatLng spotLatLng = spot.location;

        final photoUrl =
            spot.photoUrl ??
            'https://via.placeholder.com/400x300.png?text=No+Image';

        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          body: Stack(
            children: [
              // Fullscreen background image
              Positioned.fill(
                child: Image.network(photoUrl, fit: BoxFit.cover),
              ),

              // Black overlay
              Positioned.fill(
                child: Container(color: Colors.black.withAlpha(80)),
              ),

              // UI content depending on orientation
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child:
                      isLandscape
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Mini map on the left
                              buildMiniMap(context, spotLatLng),
                              // Info card on the right
                              buildInfoCard(context, spot),
                            ],
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: buildMiniMap(context, spotLatLng),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: buildInfoCard(context, spot),
                              ),
                            ],
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMiniMap(BuildContext context, LatLng spotLatLng) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return DraggableScrollableSheet(
              expand: true,
              builder: (context, scrollController) {
                return SafeArea(child: FullMapView(spotLatLng: spotLatLng));
              },
            );
          },
        );
      },
      child: Stack(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: spotLatLng,
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
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
          const Positioned(
            bottom: 8,
            right: 8,
            child: Icon(Icons.fullscreen, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(BuildContext context, SurfSpot spot) {
    return SizedBox(
      width: 260,
      child: Card(
        color: const Color(0xCCA2D8F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spot.destination,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Type: ${spot.breakTypes.isNotEmpty ? spot.breakTypes.join(', ') : 'N/A'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Difficulty: ${spot.difficultyLevel} / 5',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Season: '
                '${spot.peakSeasonStart != null ? DateFormat.yMMMd().format(spot.peakSeasonStart!) : 'N/A'}'
                ' to '
                '${spot.peakSeasonEnd != null ? DateFormat.yMMMd().format(spot.peakSeasonEnd!) : 'N/A'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              if (spot.magicSeaweedLink != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final Uri url = Uri.parse(spot.magicSeaweedLink!);

                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Aucune application disponible pour ouvrir le lien')),
                    );
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
    );
  }
}

class FullMapView extends StatelessWidget {
  final LatLng spotLatLng;
  const FullMapView({super.key, required this.spotLatLng});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carte complète")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: spotLatLng,
          initialZoom: 15,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              LatLng(-85.0, -180.0), // Sud-Ouest - coin inférieur gauche
              LatLng(85.0, 180.0),   // Nord-Est - coin supérieur droit
            ),
          ),
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate, // Désactive la rotation si nécessaire
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
    );
  }
}
