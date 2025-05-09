// lib/components/card.dart

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../models/surf_spot.dart';

class SurfSpotCard extends StatelessWidget {
  final SurfSpot spot;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const SurfSpotCard({
    super.key,
    required this.spot,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd(); // e.g. “Jul 22, 2024”

    return GFCard(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      boxFit: BoxFit.cover,
      elevation: 4,

      // show the photo if we have one:
      image:
          spot.photoUrl != null
              ? Image.network(
                spot.photoUrl!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        Container(height: 120, color: Colors.grey[200]),
              )
              : null,

      title: GFListTile(
        title: Text(
          spot.destination,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subTitle: Text('Difficulty: ${spot.difficultyLevel}'),
      ),

      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(spot.address),
          const SizedBox(height: 4),
          Text(
            'Season: ${df.format(spot.peakSeasonStart)} - ${df.format(spot.peakSeasonEnd)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),

      buttonBar: GFButtonBar(
        children: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}
