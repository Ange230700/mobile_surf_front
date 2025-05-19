// lib/utils/position.dart

import 'dart:convert';
import 'package:latlong2/latlong.dart';

LatLng parseLatLng(String rawGeocode) {
  // 1) First, try to decode as Base64-encoded JSON
  try {
    final decodedJson = utf8.decode(base64Decode(rawGeocode));
    final data = json.decode(decodedJson);
    if (data is Map<String, dynamic> && data.containsKey('o')) {
      final o = data['o'];
      if (o is Map<String, dynamic> &&
          o.containsKey('lat') &&
          o.containsKey('lng')) {
        return LatLng(
          (o['lat'] as num).toDouble(),
          (o['lng'] as num).toDouble(),
        );
      }
    }
  } catch (_) {
    // ignore and fall through to next strategy
  }

  // 2) If that fails, maybe it's a JSON array string: "[lat, lng]"
  try {
    final arr = json.decode(rawGeocode);
    if (arr is List && arr.length >= 2) {
      final lat = (arr[0] as num).toDouble();
      final lng = (arr[1] as num).toDouble();
      return LatLng(lat, lng);
    }
  } catch (_) {
    // ignore
  }

  // 3) Lastly, try a simple comma-separated "lat,lng"
  final parts = rawGeocode.split(',');
  if (parts.length == 2) {
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
  }

  throw FormatException('Invalid geocode format: $rawGeocode');
}
