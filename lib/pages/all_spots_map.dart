import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
// import '../services/airtable_api.dart';
import '../services/surfspot_api.dart';
import '../models/surf_spot.dart';

class AllSpotsMap extends StatefulWidget {
  const AllSpotsMap({super.key});

  @override
  State<AllSpotsMap> createState() => _AllSpotsMapState();
}

class _AllSpotsMapState extends State<AllSpotsMap> {
  late final Future<List<SurfSpot>> _spotsFuture;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _spotsFuture = SurfSpotApi().fetchSurfSpots();
    
    // Forcer un redraw de la carte après un court délai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _mapController.camera.zoom == 10) {
          // Zoom léger pour forcer le chargement des tuiles
          _mapController.move(_mapController.camera.center, 10.1);
          // Revenir au zoom initial
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _mapController.move(_mapController.camera.center, 10);
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SurfSpot>>(
      future: _spotsFuture,
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

        final spots = snapshot.data!;
        // build markers from each spot's `location`
        final markers =
            spots.map((spot) {
              return Marker(
                point: spot.location,
                width: 30,
                height: 30,
                child: const Icon(
                  Icons.location_on, 
                  size: 30,
                  color: Colors.redAccent,
                ),
              );
            }).toList();

        // once we have markers, fit the map's bounds to include them all
        if (markers.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final bounds = LatLngBounds.fromPoints(
              markers.map((m) => m.point).toList(),
            );
            _mapController.fitCamera(
              CameraFit.bounds(
                bounds: bounds,
                padding: const EdgeInsets.all(24),
              ),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(title: const Text('All Surf Spots Map')),
          body: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(0, 0),
              initialZoom: 10,
              minZoom: 2, // Limite le niveau minimum de zoom
              maxZoom: 18, // Limite le niveau maximum de zoom
              // Limites des coordonnées de la map (monde entier)
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  LatLng(-85.0, -180.0), // Sud-Ouest - coin inférieur gauche
                  LatLng(85.0, 180.0),   // Nord-Est - coin supérieur droit
                ),
              ),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate, // Désactive la rotation si nécessaire
              ),
              // Forcer le chargement initial des tuiles
              onMapReady: () {
                // Petit trick pour forcer le chargement des tuiles
                _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 0.01);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 0.01);
                  }
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CancellableNetworkTileProvider(),
                minZoom: 2, // Limite le niveau minimum de zoom pour les tuiles
                maxZoom: 18, // Limite le niveau maximum de zoom pour les tuiles
              ),
              MarkerLayer(markers: markers),
            ],
          ),
        );
      },
    );
  }
}