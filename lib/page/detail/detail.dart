import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exemple/main.dart';
import 'package:exemple/page/models/lieu.dart';

class DetailPage extends StatelessWidget {

  final Lieu lieu;
  DetailPage({required this.lieu, super.key});

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<MyAppState>().favorites.contains(lieu);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(''), // Titre déplacé dans la carte
      ),
      body: Stack(
        children: [
          // Image de fond pleine page
          Positioned.fill(
            child: Image.network(
              lieu.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          // Fond semi-transparent optionnel
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Carte en bas à droite
          Positioned(
            bottom: 32,
            right: 16,
            child: Card(
              color: const Color(0xCCA2D8F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.25, // max 70% de la largeur écran
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              lieu.nom,
                              style: const TextStyle(
                                fontFamily: 'JoseFinSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.black,
                            ),
                            onPressed: () => context.read<MyAppState>().toggleFavorite(lieu),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lieu.description,
                        style: const TextStyle(
                          fontFamily: 'JoseFinSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}