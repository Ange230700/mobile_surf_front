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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main photo or first of multiple
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
            // Thumbnails for additional photos
            // if (spot.photoUrls.isNotEmpty)
            //   SizedBox(
            //     height: 60,
            //     child: ListView.separated(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: spot.photoUrls.length,
            //       separatorBuilder: (_, __) => const SizedBox(width: 8),
            //       itemBuilder: (context, idx) {
            //         return ClipRRect(
            //           borderRadius: BorderRadius.circular(6),
            //           child: Image.network(
            //             spot.photoUrls[idx],
            //             width: 60,
            //             height: 60,
            //             fit: BoxFit.cover,
            //             errorBuilder:
            //                 (_, __, ___) => Container(
            //                   width: 60,
            //                   height: 60,
            //                   color: Colors.grey[300],
            //                   child: const Icon(Icons.broken_image, size: 16),
            //                 ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),

            // const SizedBox(height: 8),
            Text(
              spot.destination,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text('Difficulty: ${spot.difficultyLevel}'),

            const SizedBox(height: 4),
            Text(spot.address, style: const TextStyle(fontSize: 16)),
            Text(
              spot.peakSeasonStart != null && spot.peakSeasonEnd != null
                  ? 'Season: ${df.format(spot.peakSeasonStart!)} - ${df.format(spot.peakSeasonEnd!)}'
                  : 'Season: N/A',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 8),
            // Break types as chips
            if (spot.breakTypes.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: -8,
                children:
                    spot.breakTypes
                        .map(
                          (type) => Chip(
                            label: Text(
                              type,
                              style: const TextStyle(fontSize: 16),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
              ),

            // Influencers or local heroes
            // if (spot.influencers.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 8),
            //     child: Row(
            //       children: [
            //         const Icon(Icons.person, size: 16),
            //         const SizedBox(width: 4),
            //         Expanded(
            //           child: Text(
            //             'Influencers: ${spot.influencers.join(', ')}',
            //             style: const TextStyle(fontSize: 12),
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

            // const SizedBox(height: 8),
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
