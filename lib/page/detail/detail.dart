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
      appBar: AppBar(
        title: Text(lieu.nom),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () => context.read<MyAppState>().toggleFavorite(lieu),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
        // on force une hauteur min = hauteur de l'écran
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
            // ici, on centre verticalement
            mainAxisAlignment: MainAxisAlignment.center,
            // et horizontalement
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Image.network(lieu.imageUrl),
                const SizedBox(height: 16),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    lieu.description,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center, // pour que le texte soit bien centré
                    ),
                ),
                // … autres widgets
                ],
            ), 
        ),
      ),

    );
  }
}
