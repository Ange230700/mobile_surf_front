import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> record;

  const DetailPage({required this.record, super.key});

  @override
  Widget build(BuildContext context) {
    final fields = record['fields'] ?? {};
    final String imageUrl = (fields['Photos'] != null && fields['Photos'].isNotEmpty)
        ? fields['Photos'][0]['url']
        : 'https://via.placeholder.com/400x300.png?text=No+Image';
    final String destination = fields['Destination'] ?? 'Unknown Spot';
    final String surfBreak = (fields['Surf Break'] != null && fields['Surf Break'].isNotEmpty)
        ? (fields['Surf Break'] as List).join(', ')
        : 'Unknown Type';
    final int? difficulty = fields['Difficulty Level'];
    final String seasonStart = fields['Peak Surf Season Begins'] ?? '';
    final String seasonEnd = fields['Peak Surf Season Ends'] ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(''),
      ),
      body: Stack(
        children: [
          // Image de fond pleine page
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          // Fond semi-transparent optionnel
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Carte en bas à droite - CORRIGÉ
          Positioned(
            bottom: 32,
            right: 16,
            child: Container(
              width: 250, // Largeur fixe pour la Card
              child: Card(
                color: const Color(0xCCA2D8F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination,
                        style: const TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Type: $surfBreak',
                        style: const TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Difficulty: ${difficulty?.toString() ?? 'N/A'} / 5',
                        style: const TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Season: $seasonStart to $seasonEnd',
                        style: const TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final url = fields['Magic Seaweed Link'];
                          if (url != null) {
                            // You can use url_launcher here to open the link if needed
                          }
                        },
                        child: const Text(
                          'View Surf Report',
                          style: TextStyle(color: Colors.black),
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