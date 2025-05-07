// lib/utils/position.dart

import 'dart:convert';
import 'package:latlong2/latlong.dart';

LatLng parseLatLng(String rawGeocode) {
  try {
    // detect a Base64 payload (letters, digits, +, /, padding =)
    final base64Reg = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    if (base64Reg.hasMatch(rawGeocode)) {
      final decoded = utf8.decode(base64Decode(rawGeocode));
      final data = json.decode(decoded);
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
    }
  } catch (_) {
    // if decoding/parsing fails, fall through to the next strategy
  }

  try {
    final data = json.decode(rawGeocode);
    if (data is List && data.length >= 2) {
      final lat =
          (data[0] is num)
              ? data[0].toDouble()
              : double.parse(data[0].toString());
      final lng =
          (data[1] is num)
              ? data[1].toDouble()
              : double.parse(data[1].toString());
      return LatLng(lat, lng);
    }
  } catch (_) {
    // fall through
  }

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
