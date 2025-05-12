// lib\pages\favori.dart

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../components/card.dart';
import '../models/surf_spot.dart';

class FavoritesPage extends StatelessWidget {
  final List<SurfSpot> spots;
  final Set<int> favoriteIndices;
  final void Function(int) onFavoriteToggle;

  const FavoritesPage({
    super.key,
    required this.spots,
    required this.favoriteIndices,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      itemCount: favoriteIndices.length,
      itemBuilder: (context, index) {
        final spotIndex = favoriteIndices.elementAt(index);
        final spot = spots[spotIndex];
        return SurfSpotCard(
          spot: spot,
          isFavorite: true,
          onFavoriteToggle: () => onFavoriteToggle(spotIndex),
        );
      },
    );
  }
}
