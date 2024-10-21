import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'liste_adherents.dart';
import 'adherents_page.dart';
import 'agenda_page.dart';
import 'parametres.dart';
import 'parametres_page.dart';

Future<void> main() async {
  Parametres instanceParametres = Parametres.instance;
  await instanceParametres.lectureFichierParametres();
  await instanceParametres.ecritureFichierParametres();

  ListeAdherents instanceListeAdherent = ListeAdherents.instance;
  await instanceListeAdherent.lectureFichierAdherents();

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
  Adherent editAd = Adherent("", "", "");

  TextEditingController myControllerTextFieldRecherche =
      TextEditingController();
  MyAppState() {
    myControllerTextFieldRecherche.addListener(() {
      // Effectuer votre traitement ici
      //print(myControllerTextFieldRecherche
      //    .text); // Par exemple, afficher le texte dans la console
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

  void searchStrinInName(String text) {
    ListeAdherents.instance.searchStingInName(text);
    notifyListeners();
  }

  String resultatRecherche() {
    String nombreTrouve = "";
    if (ListeAdherents.instance.listeAdherentsCourant.isEmpty) {
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

  void deleteAdherent(Adherent adherent) {
    ListeAdherents.instance.deleteAdherent(adherent);
    notifyListeners();
  }

  void majAdherentEdite(Adherent localCurrentAd) {
    ListeAdherents.instance.majAdherentEdite(editAd, localCurrentAd);
    notifyListeners();
  }

  void createAdherentEdite() {
    ListeAdherents.instance.createAdherentEdite(editAd);
    notifyListeners();
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
        page = AdherentsPage();
        break;
      case 1:
        page = AgendaPage();
        break;
      case 2:
        page = AgendaPage();
        break;
      case 3:
        page = AgendaPage();
        break;
      case 4:
        page = ParametresPage();
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
                backgroundColor: Theme.of(context).hoverColor,
                //  const Color.fromARGB(255, 111, 165, 113),
//                extended: constraints.maxWidth >= 600, // ← Here.
                labelType: NavigationRailLabelType.all,

                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.contacts),
                    label: Text('Adhérents'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_month),
                    label: Text('Agenda'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.euro),
                    label: Text('Bon de sortie'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.query_stats),
                    label: Text('Statistiques'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Paramètres'),
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
