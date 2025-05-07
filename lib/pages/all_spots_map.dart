// lib\pages\all_spots_map.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../utils/position.dart';

class AllSpotsMap extends StatefulWidget {
  const AllSpotsMap({super.key});
  @override
  State<AllSpotsMap> createState() => _AllSpotsMapState();
}

class _AllSpotsMapState extends State<AllSpotsMap> {
  List<Marker> _markers = [];
  LatLng _center = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _loadAllSpots();
  }

  Future<void> _loadAllSpots() async {
    final jsonString = await rootBundle.loadString('assets/data/records.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final List recs = data['records'] as List;

    final List<Marker> markers = [];
    for (var rec in recs) {
      final fields = rec['fields'] as Map<String, dynamic>;
      final geo = fields['Geocode'] as String;
      final latLng = parseLatLng(geo);
      markers.add(
        Marker(
          point: latLng,
          width: 30,
          height: 30,
          child: const Icon(Icons.location_on, size: 30),
        ),
      );
    }

    setState(() {
      _markers = markers;
      if (markers.isNotEmpty) _center = markers.first.point;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Surf Spots Map')),
      body: FlutterMap(
        options: MapOptions(initialCenter: _center, initialZoom: 13.0),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }
}
