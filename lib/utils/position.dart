// lib\utils\position.dart

import 'dart:convert';
import 'package:latlong2/latlong.dart';

LatLng parseLatLng(String rawGeocode) {
  try {
    final data = json.decode(rawGeocode);
    if (data is List && data.length >= 2) {
      final lat =
          (data[0] is num)
              ? (data[0] as num).toDouble()
              : double.parse(data[0].toString());
      final lng =
          (data[1] is num)
              ? (data[1] as num).toDouble()
              : double.parse(data[1].toString());
      return LatLng(lat, lng);
    }
  } catch (_) {
    // fall through to next parsing strategy
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
