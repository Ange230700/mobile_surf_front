// lib/page/home.dart

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../components/card.dart';
import '../components/footer.dart';
import '../components/header.dart';
import 'favori.dart';
// import '../services/airtable_api.dart';
import '../services/surfspot_api.dart';
// import '../models/surf_spot.dart';
import '../models/surf_spot_2.dart';
import 'detail.dart';
import '../utils/calculate_cross_axis_count.dart';

class SurfSpotsGrid extends StatefulWidget {
  const SurfSpotsGrid({super.key});

  @override
  State<SurfSpotsGrid> createState() => _SurfSpotsGridState();
}

class _SurfSpotsGridState extends State<SurfSpotsGrid> {
  late Future<List<SurfSpot2>> _spotsFuture;
  int selectedIndex = 0;
  final _api = SurfSpotApi();
  final Set<int> _favoriteIndices = {};

  @override
  void initState() {
    super.initState();
    _spotsFuture = _api.fetchSurfSpots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Header(title: 'Surf Spots'), centerTitle: true),
      body: FutureBuilder<List<SurfSpot2>>(
        future: _spotsFuture,
        builder: (context, AsyncSnapshot<List<SurfSpot2>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data'));
          }
          final spots = snapshot.data!;
          Widget page;
          switch (selectedIndex) {
            case 0:
              page = LayoutBuilder(
                builder: (context, constraints) {
                  final cols = calculateCrossAxisCount(constraints.maxWidth);
                  return AlignedGridView.count(
                    crossAxisCount: cols,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    itemCount: spots.length,
                    itemBuilder: (context, index) {
                      final spot = spots[index];
                      final isFavorite = _favoriteIndices.contains(index);
                  
                      return SurfSpotCard(
                        spot: spot,
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
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DetailPage(spotId: spot.id),
                              ),
                            ),
                      );
                    },
                  );
                }
              );
            case 1:
              page = FavoritesPage(
                spots: snapshot.data!,
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
