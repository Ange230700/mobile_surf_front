// lib\utils\position.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:latlong2/latlong.dart';

LatLng parseLatLng(String rawGeocode) {
  if (rawGeocode.isEmpty) {
    throw FormatException("Empty geocode string");
  }
  final match = RegExp(r'^🔵\s*(.*)').firstMatch(rawGeocode);
  if (match == null) {
    throw FormatException("Invalid geocode format: $rawGeocode");
  }
  final b64Part = match.group(1)!;
  final sanitized = b64Part.replaceAll(RegExp(r'\s+'), '');
  Uint8List bytes;
  try {
    bytes = base64.decode(sanitized);
  } on FormatException {
    bytes = base64Url.decode(sanitized);
  }
  final jsonStr = utf8.decode(bytes);
  final map = json.decode(jsonStr) as Map<String, dynamic>;
  final coords = map['o'] as Map<String, dynamic>;
  return LatLng(
    (coords['lat'] as num).toDouble(),
    (coords['lng'] as num).toDouble(),
  );
}
