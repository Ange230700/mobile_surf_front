// lib/models/surf_spot.dart

import 'package:latlong2/latlong.dart';
import '../utils/position.dart';

class SurfSpot {
  final String id;
  final String destination;
  final String address;
  final int difficultyLevel;
  final DateTime peakSeasonStart;
  final DateTime peakSeasonEnd;
  final String? photoUrl;

  final LatLng location;

  SurfSpot({
    required this.id,
    required this.destination,
    required this.address,
    required this.difficultyLevel,
    required this.peakSeasonStart,
    required this.peakSeasonEnd,
    this.photoUrl,
    required this.location,
  });

  factory SurfSpot.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};

    // extract the first photo URL if present
    String? photo;
    final photos = fields['Photos'] as List<dynamic>?;
    if (photos != null && photos.isNotEmpty) {
      photo = (photos[0] as Map<String, dynamic>)['url'] as String?;
    }

    // parse the geocode into a LatLng:
    final rawGeocode = fields['Geocode'] as String? ?? '';
    LatLng loc;
    try {
      loc = parseLatLng(rawGeocode);
    } catch (_) {
      loc = const LatLng(0, 0);
    }

    return SurfSpot(
      id: json['id'] as String,
      destination: fields['Destination'] as String? ?? 'Unknown',
      address: fields['Address'] as String? ?? '',
      difficultyLevel: (fields['Difficulty Level'] as num?)?.toInt() ?? 0,
      peakSeasonStart: DateTime.parse(
        fields['Peak Surf Season Begins'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      peakSeasonEnd: DateTime.parse(
        fields['Peak Surf Season Ends'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      photoUrl: photo,
      location: loc,
    );
  }
}
