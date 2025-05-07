// lib\utils\position.dart

import 'dart:convert';
import 'package:latlong2/latlong.dart';

LatLng parseLatLng(String rawGeocode) {
  final b64 = rawGeocode.replaceFirst(RegExp(r'^🔵\s*'), '');
  final jsonStr = utf8.decode(base64.decode(b64));
  final map = json.decode(jsonStr) as Map<String, dynamic>;
  final coords = map['o'] as Map<String, dynamic>;
  return LatLng(coords['lat'] as double, coords['lng'] as double);
}
