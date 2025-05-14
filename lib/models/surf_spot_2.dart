// lib\models\surf_spot_2.dart

import 'package:latlong2/latlong.dart';
import '../utils/position.dart';

class SurfSpot2 {
  final String id;
  final String destination;
  final String address;
  final int difficultyLevel;
  final DateTime? peakSeasonStart;
  final DateTime? peakSeasonEnd;
  final String? photoUrl;

  final LatLng location;

  final List<String> photoUrls;
  final List<String> breakTypes;
  final List<String> influencers;

  SurfSpot2({
    required this.id,
    required this.destination,
    required this.address,
    required this.difficultyLevel,
    this.peakSeasonStart,
    this.peakSeasonEnd,
    this.photoUrl,
    required this.location,
    this.photoUrls = const [],
    this.breakTypes = const [],
    this.influencers = const [],
  });

  factory SurfSpot2.fromJson(Map<String, dynamic> json) {
    // parse geocodeRaw the same way as before
    LatLng loc;
    try {
      loc = parseLatLng(json['geocodeRaw'] as String? ?? '');
    } catch (_) {
      loc = const LatLng(0, 0);
    }

    String? begin = json['peakSeasonBegin'] as String?;
    String? end = json['peakSeasonEnd'] as String?;

    return SurfSpot2(
      id: json['surfSpotId'].toString(), // use the int ID
      destination: json['destination'] as String? ?? 'Unknown',
      address: json['address'] as String? ?? '',
      difficultyLevel: (json['difficultyLevel'] as num?)?.toInt() ?? 0,
      peakSeasonStart: begin != null ? DateTime.parse(begin) : null,
      peakSeasonEnd: end != null ? DateTime.parse(end) : null,
      photoUrl: null, // unless you extend the back-end to include photos
      location: loc,
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      breakTypes: List<String>.from(json['breakTypes'] ?? []),
      influencers: List<String>.from(json['influencers'] ?? []),
    );
  }
}
