// lib/services/surfspot_api.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/surf_spot.dart';

class SurfSpotApi {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  /// GET api/SurfSpot/all
  Future<List<SurfSpot>> fetchSurfSpots() async {
    final uri = Uri.parse('$_baseUrl/api/SurfSpot/all');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('API error: ${resp.statusCode}');
    }
    final List<dynamic> data = json.decode(resp.body);
    return data.map((e) => SurfSpot.fromJson(e)).toList();
  }

  /// GET /api/surfspot/{id}
  Future<SurfSpot> fetchSurfSpotById(String id) async {
    final uri = Uri.parse('$_baseUrl/api/SurfSpot/$id');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('API error: ${resp.statusCode}');
    }
    final data = json.decode(resp.body) as Map<String, dynamic>;
    return SurfSpot.fromJson(data);
  }
}
