// lib/page/home.dart

import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;
import '../components/card.dart';
import '../components/footer.dart';
import '../components/header.dart';
import 'favori.dart';
import '../services/airtable_api.dart';
import '../models/surf_spot.dart';


class SurfSpotsGrid extends StatefulWidget {
  const SurfSpotsGrid({super.key});

  @override
  State<SurfSpotsGrid> createState() => _SurfSpotsGridState();
}

class _SurfSpotsGridState extends State<SurfSpotsGrid> {
  late Future<List<SurfSpot>> _spotsFuture;
  int selectedIndex = 0;
  final _api = AirtableApi();
  final Set<int> _favoriteIndices = {};

  @override
  void initState() {
    super.initState();
    _spotsFuture =  _api.fetchSurfSpots();
  }

  // Future<List<dynamic>> _loadSurfSpots() async {
  //   final records = await AirtableService().fetchSurfSpots();
  //   final jsonString = await rootBundle.loadString('assets/data/records.json');
  //   final Map<String, dynamic> data = json.decode(jsonString);
  //   return data['records'] as List<dynamic>;
  // }

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
          Widget page;
          switch (selectedIndex) {
            case 0:
              page = GridView.builder(
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
                  final isFavorite = _favoriteIndices.contains(index);

                  return SurfSpotCard(
                    record: spot.toJson(),
                    isFavorite: isFavorite,
                    onFavoriteToggle: () {
                      setState(() {
                        if (isFavorite) {
                          _favoriteIndices.remove(index);
                        } else {
                          _favoriteIndices.add(index);
                        }
                      });
                    },
                  );
                },
              );
            case 1:
              page = FavoritesPage(
                spots: spots.map((s) => s.toJson()).toList(),
                favoriteIndices: _favoriteIndices,
                onFavoriteToggle: (int index) {
                  setState(() {
                    _favoriteIndices.remove(index);
                  });
                },
              );
              break;
            default:
              page = const SizedBox.shrink();
          }
          return page;
        },
      ),
      bottomNavigationBar: Footer(
        onHomePressed: () => setState(() => selectedIndex = 0),
        onFavoritesPressed: () => setState(() => selectedIndex = 1),
      ),
    );
  }
}
