// lib\components\card.dart

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../models/surf_spot.dart';

class SurfSpotCard extends StatelessWidget {
  final SurfSpot spot;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;

  const SurfSpotCard({
    super.key,
    required this.spot,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: GFCard(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        content: Column(
          mainAxisSize: MainAxisSize.min, // Empêche les débordements
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (spot.photoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  spot.photoUrl!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              spot.destination,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('Difficulty: ${spot.difficultyLevel}'),
            const SizedBox(height: 4),
            Text(spot.address, style: const TextStyle(fontSize: 12)),
            Text(
              'Season: ${df.format(spot.peakSeasonStart)} - ${df.format(spot.peakSeasonEnd)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: onFavoriteToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
