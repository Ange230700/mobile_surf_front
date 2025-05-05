// lib/main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'components/header.dart';
import 'components/footer.dart';
import 'page/favori.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surf Spots',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0E5386),
          secondary: Color(0xFFA2D8F7),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0E5386),
          foregroundColor: Colors.white,
        ),
        textTheme: GoogleFonts.josefinSansTextTheme(),
      ),
      home: const SurfSpotsGrid(),
    );
  }
}

class SurfSpotsGrid extends StatefulWidget {
  const SurfSpotsGrid({super.key});

  @override
  State<SurfSpotsGrid> createState() => _SurfSpotsGridState();
}

class _SurfSpotsGridState extends State<SurfSpotsGrid> {
  late Future<List<dynamic>> _spotsFuture;
  int selectedIndex = 0;
  final Set<int> _favoriteIndices = {};

  @override
  void initState() {
    super.initState();
    _spotsFuture = _loadSurfSpots();
  }

  Future<List<dynamic>> _loadSurfSpots() async {
    final jsonString = await rootBundle.loadString('assets/data/records.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    return data['records'] as List<dynamic>;
  }

  String _cleanUrl(String raw) => raw.replaceAll(RegExp(r'[<>;]'), '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Header(title: 'Surf Spots'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _spotsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          final spots = snapshot.data!;
          // Build pages
          Widget page;
          switch (selectedIndex) {
            case 0:
              // Grid view page
              page = GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: spots.length,
                itemBuilder: (context, index) {
                  final record = spots[index]['fields'] as Map<String, dynamic>;
                  final destination = record['Destination'] as String;
                  final difficulty = record['Difficulty Level'].toString();
                  final seasonStart = record['Peak Surf Season Begins'] as String;
                  final seasonEnd = record['Peak Surf Season Ends'] as String;
                  final photos = record['Photos'] as List<dynamic>?;
                  String imageUrl = '';
                  if (photos != null && photos.isNotEmpty) {
                    imageUrl = _SurfSpotsGridState()._cleanUrl(photos[0]['url'] as String);
                    //imageUrl = _cleanUrl(photos[0]['url'] as String);
                  }
                  final isFavorite = _favoriteIndices.contains(index);

                  return Card(
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    if (imageUrl.isNotEmpty)
                      Expanded(child: Image.network(imageUrl, fit: BoxFit.cover)),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(destination, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Difficulty: $difficulty'),
                          Text('Season: $seasonStart - $seasonEnd'),
                        ],
                      ),
                    ),
                    // ← NOUVEAU: bouton Like / Dislike
                    OverflowBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                          color: isFavorite
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            setState(() {
                              if (isFavorite) {
                                _favoriteIndices.remove(index);
                              } else {
                                _favoriteIndices.add(index);
                              }
                            });
                          },
                       ),
                      ],
                    ),
                  ],
                ),
              );
             },
           );
              break;
            case 1:
              // Favorites page, pass via constructor
              page = FavoritesPage(
                spots: snapshot.data!,
                favoriteIndices: _favoriteIndices,
              );
              break;
            default:
              page = const SizedBox.shrink();
          }
          return page;
        },
      ),
      bottomNavigationBar: Footer(
        onHomePressed: () => setState(() => selectedIndex = 0),
        onFavoritesPressed: () => setState(() => selectedIndex = 1),
      ),
    );
  }
}


// Removed the _cleanUrl class as it is unnecessary.