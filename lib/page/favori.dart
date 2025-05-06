import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<dynamic> spots;
  final Set<int> favoriteIndices;

  const FavoritesPage({
    super.key,
    required this.spots,
    required this.favoriteIndices,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favoriteIndices.length,
      itemBuilder: (context, index) {
        final spotIndex = favoriteIndices.elementAt(index);
        final record = spots[spotIndex]['fields'] as Map<String, dynamic>;
        final destination = record['Destination'] as String;
        final difficulty = record['Difficulty Level'].toString();
        final seasonStart = record['Peak Surf Season Begins'] as String;
        final seasonEnd = record['Peak Surf Season Ends'] as String;
        final photos = record['Photos'] as List<dynamic>?;
        String imageUrl = '';
        if (photos != null && photos.isNotEmpty) {
          imageUrl = _SurfSpotsGridState()._cleanUrl(
            photos[0]['url'] as String,
          );
        }

        return Card(
          child: Column(
            children: [
              if (imageUrl.isNotEmpty) Image.network(imageUrl),
              Text(destination),
              Text('Difficulty: $difficulty'),
              Text('Season: $seasonStart - $seasonEnd'),
            ],
          ),
        );
      },
    );
  }
}

class _SurfSpotsGridState {
  String _cleanUrl(String photo) {
    // Example implementation: return the photo URL as is
    return photo;
  }
}
