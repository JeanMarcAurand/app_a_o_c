import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'liste_adherents.dart';

Future<void> main() async {
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
  Adherent currentAd = ListeAdherents.instance.adherentCourant;
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

  void setAdherentPrecedent() {
    ListeAdherents.instance.setAdherentPrecedent();
    currentAd = ListeAdherents.instance.adherentCourant;
    notifyListeners();
  }

  void setAdherentSuivant() {
    ListeAdherents.instance.setAdherentSuivant();
    currentAd = ListeAdherents.instance.adherentCourant;
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

  void deleteAdherentCourant() {
    ListeAdherents.instance.deleteAdherentCourant();
    currentAd = ListeAdherents.instance.adherentCourant;
    notifyListeners();
  }

  void majAdherentEdite() {
    ListeAdherents.instance.majAdherentEdite(editAd);
    notifyListeners();
  }

  void createAdherentEdite() {
    ListeAdherents.instance.createAdherentEdite(editAd);
    currentAd = ListeAdherents.instance.adherentCourant;
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
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = FavoritesPage();
        break;
      case 3:
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
                backgroundColor: Theme.of(context).hoverColor,
                //  const Color.fromARGB(255, 111, 165, 113),
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
                  NavigationRailDestination(
                    icon: Icon(Icons.euro),
                    label: Text('Bon de sortie'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste adhérents',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BarreNavigation(pair: pair),
            SizedBox(height: 10),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: FicheAdherent(
                  enableEditBool: false, adherent: appState.currentAd),
            ),
            SizedBox(height: 10),
            BarreEdition(pair: pair),
          ],
        ),
      ),
    );
  }
}

class FicheAdherent extends StatelessWidget {
  final bool enableEditBool;
  final Adherent adherent;
  FicheAdherent(
      {super.key, required this.enableEditBool, required this.adherent});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: ChampTexte(
                      labelTextDecoration: "Mme,M",
                      labelText: adherent.civilite,
                      enableEdit: enableEditBool,
                      callback: adherent.setCivilite,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "* Nom",
                      labelText: adherent.nom,
                      enableEdit: enableEditBool,
                      callback: adherent.setNom,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Prenom",
                      labelText: adherent.prenom,
                      enableEdit: enableEditBool,
                      callback: adherent.setPrenom,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
              ],
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 20),
                  Flexible(
                    flex: 2,
                    child: ChampTexte(
                      labelTextDecoration: "Numéro",
                      labelText: adherent.noRue,
                      enableEdit: enableEditBool,
                      callback: adherent.setNoRue,
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: ChampTexte(
                      labelTextDecoration: "Adresse",
                      labelText: adherent.adresse,
                      enableEdit: enableEditBool,
                      callback: adherent.setAdresse,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
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
                      labelText: adherent.complementAdresse,
                      enableEdit: enableEditBool,
                      callback: adherent.setComplementAdresse,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
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
                      labelText: adherent.codePostal,
                      enableEdit: enableEditBool,
                      callback: adherent.setCodePostal,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Commune",
                      labelText: adherent.commune,
                      enableEdit: enableEditBool,
                      callback: adherent.setCommune,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
              ],
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(width: 20),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "* Téléphone",
                      labelText: adherent.noTelephone,
                      enableEdit: enableEditBool,
                      callback: adherent.setNoTelephone,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "@ mail",
                      labelText: adherent.adresseMail,
                      enableEdit: enableEditBool,
                      callback: adherent.setAdresseMail,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

class ModificationFicheAdherent extends StatelessWidget {
  final bool editTrueCreateFalse;
  ModificationFicheAdherent({super.key, required this.editTrueCreateFalse});
  @override
  Widget build(BuildContext context) {
    String titreAppBar = "";
    var appState = context.watch<MyAppState>();
    if (editTrueCreateFalse) {
      titreAppBar = 'Modification de la fiche';
      appState.editAd.copyAdherentFrom(appState.currentAd);
    } else {
      titreAppBar = 'Création de la fiche';
      appState.editAd.copyAdherentFrom(Adherent("", "", ""));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(titreAppBar),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            dialogConfirmation(context, appState, editTrueCreateFalse);
          },
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: FicheAdherent(
                enableEditBool: true,
                adherent: appState.editAd,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    dialogConfirmation(context, appState, editTrueCreateFalse);
                  },
                  icon: Icon(Icons.delete_forever),
                  label: Text('Annuler'),
                  //  color: theme.colorScheme.primary,    // ← And also this.
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    dialogChampObligatoire(
                        context, appState, editTrueCreateFalse);
                  },
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.edit),
                  label: Text('Sauvegarder'),
                  //  color: theme.colorScheme.primary,    // ← And also this.
                ),
              ),
            ]),
          ]),
    );
  }
}

void dialogConfirmation(
    BuildContext context, MyAppState appState, bool editTrueCreateFalse) {
  //var appState = context.watch<MyAppState>();
  // if ((appState.editAd.nom.isNotEmpty) &&
  //    (appState.editAd.noTelephone.isNotEmpty))
  {
    if (!(appState.currentAd.isAdherentIdentique(appState.editAd))) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('La fiche d\'adhérent a été modifiée!'),
          content: const Text('Conserver les modifications:'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Non!'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                dialogChampObligatoire(context, appState, editTrueCreateFalse);

//                appState.majAdherentEdite();
                //               Navigator.pop(context);
                //              Navigator.pop(context);
              },
              child: const Text('Oui!'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
//  } else {
  // Ne passera jamais dans le else de dialogChampObligatoire,
  // il y a un champ obligatoire de vide.
  //  dialogChampObligatoire(context, appState);
  //}
}

//-----------------------------------------------------------------------
// Boite de dialogue avec gestion des champs obligatoires.
//-----------------------------------------------------------------------
void dialogChampObligatoire(
    BuildContext context, MyAppState appState, editTrueCreateFalse) {
  if ((appState.editAd.nom.isEmpty) || (appState.editAd.noTelephone.isEmpty)) {
    String champACompleter = "";
    if (appState.editAd.nom.isEmpty) {
      champACompleter = "Nom";
    } else {
      champACompleter = "Numero de téléphone";
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Le champ $champACompleter doit être renseigné!'),
        content: const Text('Reprendre les modifications ou abandonner:'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Abandonner!'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Reprendre!'),
          ),
        ],
      ),
    );
  } else {
    if (editTrueCreateFalse == true) {
      appState.majAdherentEdite();
    } else {
      appState.createAdherentEdite();
    }
    Navigator.pop(context);
  }
}

class BarreEdition extends StatelessWidget {
  // This controller will store the value of the search bar
  // final  TextEditingController _searchController = TextEditingController();

  BarreEdition({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();
  
    return Row(
        // ↓ Change this line.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Suppression de la fiche d\'adhérent'),
                    content: const Text('La suppression est définitive!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          appState.deleteAdherentCourant();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Supprimer'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete_forever),
              label: Text('Supprimer'),
              //                                    color: theme.colorScheme.primary,    // ← And also this.
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ModificationFicheAdherent(editTrueCreateFalse: true)),
                );
              },
              iconAlignment: IconAlignment.end,
              label: Text('Modifier'),
              icon: Icon(Icons.edit),
              //                                    color: theme.colorScheme.primary,    // ← And also this.
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ModificationFicheAdherent(
                          editTrueCreateFalse: false)),
                );
              },
              iconAlignment: IconAlignment.end,
              label: Text('Nouveau'),
              icon: Icon(Icons.person_add),
              //                                    color: theme.colorScheme.primary,    // ← And also this.
            ),
          ),
        ]);
  }
}

class BarreNavigation extends StatelessWidget {
  
  BarreNavigation({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();
    var myControllerTextFieldRechercheLocal =
        appState.myControllerTextFieldRecherche;

    return Row(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            appState.setAdherentPrecedent();
          },
          icon: Icon(Icons.arrow_back_ios),
          label: Text('Précédent'),
        ),
      ),
      Expanded(
        child: Column(
          children: [
            TextField(
              controller: myControllerTextFieldRechercheLocal,
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
            appState.setAdherentSuivant();
          },
          iconAlignment: IconAlignment.end,
          label: Text('Suivant'),
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ),
    ]);
  }
}
//----------------------------------------------------------------
// class ChampTexte
//----------------------------------------------------------------

class ChampTexte extends StatelessWidget {
  final String labelText;
  final String labelTextDecoration;
  final bool enableEdit;
  void Function(String) callback;

  ChampTexte({
    super.key,
    required this.labelText,
    required this.labelTextDecoration,
    required this.enableEdit,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        enabled: enableEdit, // false rend le TextField non éditable
        controller: TextEditingController(text: labelText),
        onChanged: (text) {
          callback(text);
          //print('$labelTextDecoration : $text');
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelTextDecoration,
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
