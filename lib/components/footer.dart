// lib/components/footer.dart

import 'package:flutter/material.dart';
import '../pages/all_spots_map.dart';

class Footer extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onFavoritesPressed;

  const Footer({
    super.key,
    required this.onHomePressed,
    required this.onFavoritesPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFA2D8F7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: onHomePressed,
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              tooltip: 'Favoris',
              onPressed: onFavoritesPressed,
            ),
            IconButton(
              icon: Icon(Icons.map),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AllSpotsMap()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
