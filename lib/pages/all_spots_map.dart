// lib\pages\all_spots_map.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import '../utils/position.dart';

class AllSpotsMap extends StatefulWidget {
  const AllSpotsMap({super.key});
  @override
  State<AllSpotsMap> createState() => _AllSpotsMapState();
}

class _AllSpotsMapState extends State<AllSpotsMap> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  // you can remove _center; we'll fit bounds instead

  @override
  void initState() {
    super.initState();
    _loadAllSpots();
  }

  Future<void> _loadAllSpots() async {
    final jsonString = await rootBundle.loadString('assets/data/records.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final recs = data['records'] as List;

    final List<Marker> markers = [];
    for (var rec in recs) {
      final fields = rec['fields'] as Map<String, dynamic>;
      final geo = fields['Geocode'] as String;
      try {
        final latLng = parseLatLng(geo);
        markers.add(
          Marker(
            point: latLng,
            width: 30,
            height: 30,
            child: const Icon(Icons.location_on, size: 30),
          ),
        );
      } catch (e) {
        // skip invalid geocodes
      }
    }

    if (markers.isEmpty) return;

    setState(() => _markers = markers);

    // once the map has rebuilt with markers, fit bounds:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bounds = LatLngBounds.fromPoints(
        _markers.map((m) => m.point).toList(),
      );
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(24),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Surf Spots Map')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          // zoom/center here only controls initial state, fitBounds will override
          initialCenter: LatLng(0, 0),
          initialZoom: 2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            tileProvider: CancellableNetworkTileProvider(),
            maxZoom: 19,
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }
}
