// lib/services/airtable_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/surf_spot.dart';

/// Service pour interroger l’API Airtable
class AirtableApi {
  final String _baseUrl = dotenv.env['AIRTABLE_BASE_URL']!;
  final String _apiKey  = dotenv.env['AIRTABLE_API_KEY']!;

  /// Renvoie la liste des SurfSpot via Airtable
  Future<List<SurfSpot>> fetchSurfSpots() async {
    final uri = Uri.parse(_baseUrl);
    final resp = await http.get(uri, headers: {
      'Authorization': 'Bearer $_apiKey',  
     
    });
    if (resp.statusCode != 200) {
      throw Exception('Airtable API error: ${resp.statusCode}');
    }
    final body = json.decode(resp.body) as Map<String, dynamic>;
    final records = body['records'] as List<dynamic>;
    return records
      .map((e) => SurfSpot.fromJson(e as Map<String, dynamic>))
      .toList();
  }
}
