import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'liste_adherents.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  Adherent currentAd = ListeAdherents.instance.adherentCourant;
  TextEditingController myControllerTextFieldRecherche =
      TextEditingController();
  MyAppState() {
    myControllerTextFieldRecherche.addListener(() {
      // Effectuer votre traitement ici
      print(myControllerTextFieldRecherche
          .text); // Par exemple, afficher le texte dans la console
      searchStrinInName(myControllerTextFieldRecherche.text);
    });
  }
  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // ↓ Add the code below.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void setAdherentPrecedent() {
    ListeAdherents.instance.setAdherentPrecedent();
    currentAd = ListeAdherents.instance.adherentCourant;
    print("setAdherentPrecedent $currentAd");
    notifyListeners();
  }

  void setAdherentSuivant() {
    ListeAdherents.instance.setAdherentSuivant();
    currentAd = ListeAdherents.instance.adherentCourant;
    print("setAdherentSuivant $currentAd");
    notifyListeners();
  }

  void searchStrinInName(String text) {
    ListeAdherents.instance.searchStingInName(text);
    currentAd = ListeAdherents.instance.adherentCourant;
    notifyListeners();
  }

  String resultatRecherche() {
    String nombreTrouve = "";
    if (ListeAdherents.instance.listeAdherentsCourant.isEmpty ||
    ListeAdherents.instance.adherentCourant.nom.isEmpty) {
      nombreTrouve = "Aucune fiche trouvée";
    } else {
      if (ListeAdherents.instance.listeAdherentsCourant.length == 1) {
        nombreTrouve = "Une seule fiche touvée";
      } else {
        nombreTrouve =
            '${ListeAdherents.instance.listeAdherentsCourant.length} fiches trouvées';
      }
    }
    return '$nombreTrouve sur un total de ${ListeAdherents.instance.listeAdherentsComplet.length} fiches';
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // ← Add this property.

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600, // ← Here.
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.contacts),
                    label: Text('Adhérents'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_month),
                    label: Text('Agenda'),
                  ),
                ],
                selectedIndex: selectedIndex, // ← Change to this.
                onDestinationSelected: (value) {
                  print('selected: $value');
                  // ↓ Replace print with this.
                  setState(() {
                    selectedIndex = value;
                  });
                },
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
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BarreNavigation(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: ChampTexte(
                  labelTextDecoration: "Mme,M",
                  labelText: appState.currentAd.civilite,
                ),
              ),
              Flexible(
                flex: 5,
                child: ChampTexte(
                  labelTextDecoration: "Nom",
                  labelText: appState.currentAd.nom,
                ),
              ),
              Flexible(
                flex: 5,
                child: ChampTexte(
                  labelTextDecoration: "Prenom",
                  labelText: appState.currentAd.prenom,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 20),
              Flexible(
                flex: 2,
                child: ChampTexte(
                  labelTextDecoration: "Numéro",
                  labelText: appState.currentAd.noRue,
                ),
              ),
              Flexible(
                flex: 10,
                child: ChampTexte(
                  labelTextDecoration: "Adresse",
                  labelText: appState.currentAd.adresse,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(width: 20),
              ),
              Flexible(
                flex: 10,
                child: ChampTexte(
                  labelTextDecoration: "Complement adresse",
                  labelText: appState.currentAd.complementAdresse,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(width: 20),
              ),
              Flexible(
                flex: 5,
                child: ChampTexte(
                  labelTextDecoration: "Code postal",
                  labelText: appState.currentAd.codePostal,
                ),
              ),
              Flexible(
                flex: 5,
                child: ChampTexte(
                  labelTextDecoration: "Commune",
                  labelText: appState.currentAd.commune,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(width: 20),
              ),
              Flexible(
                flex: 5,
                child: ChampTexte(
                  labelTextDecoration: "Téléphone",
                  labelText: appState.currentAd.noTelephone,
                ),
              ),
              Flexible(
                flex: 5,
                child: ChampTexte(
                  labelTextDecoration: "@ mail",
                  labelText: appState.currentAd.adresseMail,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('!! A venir !!'),
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
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class BarreNavigation extends StatelessWidget {
  // This controller will store the value of the search bar
  // final  TextEditingController _searchController = TextEditingController();

  BarreNavigation({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
//     final theme = Theme.of(context);       // ← Add this.
    // ↓ Add this.
//    final style = theme.textTheme.displayMedium!.copyWith(
//      color: theme.colorScheme.onPrimary,
//    );
    var appState = context.watch<MyAppState>();
    var myControllerTextFieldRechercheLocal =
        appState.myControllerTextFieldRecherche;

    return Row(
        // ↓ Change this line.
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                print("Précedent");
                appState.setAdherentPrecedent();
              },
              icon: Icon(Icons.arrow_back_ios),
              label: Text('Précédent'),
              //                                    color: theme.colorScheme.primary,    // ← And also this.
            ),
          ),
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: myControllerTextFieldRechercheLocal,
                  //             onChanged: (text) {
                  //               print('First text field: $text (${text.characters.length})');
                  //               appState.searchStrinInName(text);
                  //             },
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
                    // Add a clear button to the search bar
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        // perform the clear.
                        myControllerTextFieldRechercheLocal.clear();
                      },
                    ),
                    // Add a search icon or button to the search bar
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Perform the search here
                        appState.searchStrinInName(
                            myControllerTextFieldRechercheLocal.text);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                Text(appState.resultatRecherche()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                print("Suivant");
                appState.setAdherentSuivant();
              },
              iconAlignment: IconAlignment.end,
              label: Text('Suivant'),
              icon: Icon(Icons.arrow_forward_ios),
              //                                    color: theme.colorScheme.primary,    // ← And also this.
            ),
          ),
        ]);
  }
}

class ChampTexte extends StatelessWidget {
  final String labelText;
  final String labelTextDecoration;

  ChampTexte({
    required this.labelText,
    required this.labelTextDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        //                  obscureText: true,
        enabled: false, // Rend le TextField non éditable
        controller: TextEditingController(text: labelText),
        //      onChanged: onTextChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelTextDecoration,
        ),
      ),
    );
  }
}
