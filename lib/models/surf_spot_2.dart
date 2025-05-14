// lib\models\surf_spot_2.dart

import 'package:latlong2/latlong.dart';
import '../utils/position.dart';

class SurfSpot2 {
  final String id;
  final String destination;
  final String address;
  final int difficultyLevel;
  final DateTime peakSeasonStart;
  final DateTime peakSeasonEnd;
  final String? photoUrl;

  final LatLng location;

  SurfSpot2({
    required this.id,
    required this.destination,
    required this.address,
    required this.difficultyLevel,
    required this.peakSeasonStart,
    required this.peakSeasonEnd,
    this.photoUrl,
    required this.location,
  });

  factory SurfSpot2.fromJson(Map<String, dynamic> json) {
    // parse geocodeRaw the same way as before
    LatLng loc;
    try {
      loc = parseLatLng(json['geocodeRaw'] as String? ?? '');
    } catch (_) {
      loc = const LatLng(0, 0);
    }

    return SurfSpot2(
      id: json['surfSpotId'].toString(), // use the int ID
      destination: json['destination'] as String? ?? 'Unknown',
      address: json['address'] as String? ?? '',
      difficultyLevel: (json['difficultyLevel'] as num?)?.toInt() ?? 0,
      peakSeasonStart: DateTime.parse(json['peakSeasonBegin']),
      peakSeasonEnd: DateTime.parse(json['peakSeasonEnd']),
      photoUrl: null, // unless you extend the back-end to include photos
      location: loc,
    );
  }
}
