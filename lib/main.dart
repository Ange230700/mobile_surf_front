import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exemple/page/models/lieu.dart';
import 'package:exemple/page/detail/detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // 1) TA LISTE DE LIEUX (initialise-la ici ou récupère-la via un service)
  final List<Lieu> lieux = [
    Lieu(
      id: 'eiffel',
      nom: 'Tour Eiffel',
      description: 'Un monument célèbre à Paris.',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwToOo7kPicv1kC5UqWZ28ksv4FrlwknRNZA&s',
    ),
    Lieu(
      id: 'louvre',
      nom: 'Musée du Louvre',
      description: 'Le plus grand musée du monde.',
      imageUrl: 'https://i.familiscope.fr/2000x1125/smart/2024/01/22/musee-louvre-pyramide-incontournable-paris.jpg',
    ),
  ];

  
  final List<Lieu> favorites = [];

  
  void toggleFavorite(Lieu lieu) {
    if (favorites.contains(lieu)) {
      favorites.remove(lieu);
    } else {
      favorites.add(lieu);
    }
    notifyListeners();
  }
}


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
           
          ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; 
  @override
  Widget build(BuildContext context) {
    Widget page;
switch (selectedIndex) {
  case 0:
    page = LieuxPage();
    break;
  case 1:
    page = FavoritesPage();
    break;
  default:
    throw UnimplementedError('no widget for $selectedIndex');
}
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              Expanded(
            flex: 0, // vous pouvez augmenter/diminuer ce nombre
              child:SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class LieuxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appState.lieux.length,
      itemBuilder: (context, index) {
        final lieu = appState.lieux[index];
        final isFav = appState.favorites.contains(lieu);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Image.network(lieu.imageUrl, width: 60, fit: BoxFit.cover),
            title: Text(lieu.nom, style: TextStyle(fontSize: 18)),
            subtitle: Text(
              lieu.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
              onPressed: () => appState.toggleFavorite(lieu),
            ),
            onTap: () {
              // Navigation vers le détail
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailPage(lieu: lieu)),
              );
            },
          ),
        );
      },
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
        ),
    );
  }
}