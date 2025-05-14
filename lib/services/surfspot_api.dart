// lib/services/surfspot_api.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/surf_spot_2.dart';

class SurfSpotApi {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  /// GET api/SurfSpot2/all
  Future<List<SurfSpot2>> fetchSurfSpots() async {
    final uri = Uri.parse('$_baseUrl/api/SurfSpot/all');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('API error: ${resp.statusCode}');
    }
    final List<dynamic> data = json.decode(resp.body);
    return data.map((e) => SurfSpot2.fromJson(e)).toList();
  }
}
