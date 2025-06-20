import 'package:app_a_o_c/config/app_theme.dart';
import 'package:app_a_o_c/pages/agenda/filtre_config_generale.dart';
import 'package:app_a_o_c/pages/informations/informations_page.dart';
import 'package:app_a_o_c/shared/utils/app_config.dart';
import 'package:app_a_o_c/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'features/adherents/liste_adherents.dart';
import 'pages/adherents/adherents_page.dart';
import 'features/agenda/agenda.dart';
import 'pages/agenda/agenda_page.dart';
import 'features/parametres/parametres.dart';
import 'pages/parametres/parametres_page.dart';

Future<void> main() async {
  // Initialiser la localisation française
  await initializeDateFormatting('fr_FR', null);
  Intl.defaultLocale = 'fr_FR';
  Parametres instanceParametres = Parametres.instance;

  await instanceParametres.lectureFichierParametres();
  //await instanceParametres.ecritureFichierParametres();

  Agenda.instance.setAnneeAgenda(Parametres.instance.anneeFichierAgenda);

  ListeAdherents instanceListeAdherent = ListeAdherents.instance;
  await instanceListeAdherent.lectureFichierAdherents();

  // runApp(MyApp());
  runApp(ChangeNotifierProvider(
    create: (context) => MyAppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = context.watch<MyAppState>().themeMode;

    return MaterialApp(
      title: 'Namer App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      supportedLocales: [
        Locale('fr', 'FR'), // Ajout du français
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MyHomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {
  Adherent editAd = Adherent("", "", "");
  Adherent adherentQRCode = ListeAdherents.instance.listeAdherentsCourant[0];
  DateTime dateSelectionnee = currentDate;
  CaracteristiquesJournee caracteristiquesJournee = CaracteristiquesJournee();
  FiltrePourCalendier filtrePourCalendier = FiltrePourCalendier.poidsDisponible;
  int poidsPourRendezVous = 50;

  ThemeMode _themeMode =
      Parametres.instance.isDark ? ThemeMode.dark : ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); // Ceci déclenche le rebuild de tous les widgets qui écoutent
  }

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

  void majParametresNomFichierAdherent(String text) {
    Parametres.instance.nomFichierAdherents = text;
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

  void majAdherentQRCode(Adherent localCurrentAd) {
    adherentQRCode = localCurrentAd;
    notifyListeners();
  }

  void majDateSelectionnee(DateTime dateTime) {
    dateSelectionnee = dateTime;
    notifyListeners();
  }

  void majCaracteristiquesJournee() {
    notifyListeners();
  }

  void majFiltrePourCalendier(FiltrePourCalendier value) {
    filtrePourCalendier = value;
    notifyListeners();
  }

  void majPoidsPourRendezVous(int value) {
    poidsPourRendezVous = value;
    notifyListeners();
  }

  int getPoidsPourRendezVous() {
    return(poidsPourRendezVous);
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
      case 5:
        page = InformationsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: AppCard(
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
                    NavigationRailDestination(
                      icon: Icon(Icons.info),
                      label: Text('Informations'),
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
    });
  }
}
