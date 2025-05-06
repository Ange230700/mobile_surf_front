// lib/components/card.dart

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/detail.dart';  // <-- Ajout de l'import pour la page détail

class SurfSpotCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const SurfSpotCard({
    super.key,
    required this.record,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final surface = theme.colorScheme.surface;

    final fields = record['fields'] as Map<String, dynamic>;
    final destination = fields['Destination'] as String;
    final difficulty = fields['Difficulty Level'].toString();
    final seasonStart = fields['Peak Surf Season Begins'] as String;
    final seasonEnd = fields['Peak Surf Season Ends'] as String;
    final photos = fields['Photos'] as List<dynamic>?;
    final rawUrl =
        (photos != null && photos.isNotEmpty)
            ? photos[0]['url'] as String
            : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(record: record),  // <-- On passe le record complet
          ),
        );
      },
      child: GFCard(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        boxFit: BoxFit.cover,
        showImage: rawUrl != null,
        elevation: 4,
        color: surface,
        image: rawUrl != null
            ? Image.network(
                rawUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              )
            : null,
        title: GFListTile(
          title: Text(
            destination,
            style: GoogleFonts.josefinSans(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subTitle: Text(
            'Difficulty: $difficulty',
            style: GoogleFonts.josefinSans(color: secondary, fontSize: 14),
          ),
        ),
        content: Text(
          'Season: $seasonStart to $seasonEnd',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.josefinSans(fontSize: 12, color: primary),
        ),
        buttonBar: GFButtonBar(
          children: [
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              color: isFavorite ? primary : secondary,
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}
