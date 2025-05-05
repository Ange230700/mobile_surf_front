// lib/components/footer.dart
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  // recevoir des callbacks si besoin :
  final VoidCallback onHomePressed;
  final VoidCallback onFavoritesPressed;

  const Footer({
    Key? key,                           
   required this.onHomePressed,
    required this.onFavoritesPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      // Optionnel : couleur de fond
      color: const Color(0xFFA2D8F7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        // 1) Row pour aligner horizontalement les boutons
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 2) Bouton Home
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: onHomePressed,
            ),
            // 3) Bouton Favoris
            IconButton(
              icon: const Icon(Icons.favorite),
              tooltip: 'Favoris',
              onPressed: onFavoritesPressed,
            ),
          ],
        ),
      ),
    );
  }
}
