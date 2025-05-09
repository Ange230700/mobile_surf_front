// lib/services/airtable_service.dart


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/card.dart';
import '../components/footer.dart';
import '../components/header.dart';
import '../models/surf_spot.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AirtableService extends StatefulWidget {
  const AirtableService({super.key});

  @override
  State<AirtableService> createState() => _AirtableServiceState();
}
  

class _AirtableServiceState extends State<AirtableService> {
  late Future<List<SurfSpot>> _spotsFuture;
  
    final String AIRTABLE_BASE_URL = dotenv.env['AIRTABLE_BASE_URL']!; 
    final String AIRTABLE_API_KEY = dotenv.env['AIRTABLE_API_KEY']!;

  @override
  void initState() {
    super.initState();
    _spotsFuture = _fetchSurfSpots();
  }

  Future<List<SurfSpot>> _fetchSurfSpots() async {
    final url = Uri.parse(AIRTABLE_BASE_URL);
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $AIRTABLE_API_KEY',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final records = data['records'] as List<dynamic>;
      return records
      .map((record) => SurfSpot.fromJson(record))
      .toList();
    } else {
      throw Exception('API failed with status ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Header(title: 'Surf Spots'), centerTitle: true),
      body: FutureBuilder<List<SurfSpot>>(
        future: _spotsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final spots = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              return SurfSpotCard(
              record: spot.toJson(),
              isFavorite: false,
              onFavoriteToggle: () {},
          );
        },
      );
  },
  ),
      bottomNavigationBar:Footer(
        onHomePressed:() {} ,
        onFavoritesPressed: () {},
      ),
    );
  }
}




    

