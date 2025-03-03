import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class RendezVous {
  String nom = ""; // Pour avoir info min si plus dans la liste des adhérents.
  String telephone =
      ""; // Pour avoir info min si plus dans la liste des adhérents.
  int identificateur = 0; // Pour retrouver dans la liste des adhérents.

  int poidsCeuillette = 0;
  int disponibilte =
      0; // en % au moment du RDV =0 Rien de cueilli, 100% ramassé prêt à porter.

  DateTime datePriseRDV = DateTime.utc(2024, 11, 2);

  RendezVous(
      {required this.nom,
      required this.telephone,
      required this.identificateur,
      required this.poidsCeuillette,
      required this.disponibilte,
      required this.datePriseRDV});

// Convertir en JSON.
  Map<String, dynamic> toJson() => {
        'nom': nom,
        'telephone': telephone,
        'identificateur': identificateur,
        'poidsCeuillette': poidsCeuillette,
        'disponibilte': disponibilte,
        'datePriseRDV': datePriseRDV,
      };
// Créer un objet à partir du JSON
  factory RendezVous.fromJson(Map<String, dynamic> json) {
    return RendezVous(
      nom: json['nom'],
      telephone: json['telephone'],
      identificateur: json['identificateur'],
      poidsCeuillette: json['poidsCeuillette'],
      disponibilte: json['disponibilte'],
      datePriseRDV: json['datePriseRDV'],
    );
  }
}

class Journee {
  final DateTime date;

  bool chome = false; // true = chomé.

  int nombreDeMotte = 3;
  int poidsMotteMax = 250; // en kg
  int poidsMotteMin = 200; // en kg

  int poidsTotalJournee = 0;

  final List<RendezVous> listeDesRendezVous;

  Journee({
    required this.date,
    this.chome = false,
    this.nombreDeMotte = 3,
    this.poidsMotteMax = 250,
    this.poidsMotteMin = 200,
    this.poidsTotalJournee = 0,
    required this.listeDesRendezVous,
  });

  // Convertir un objet en JSON
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'chome': chome,
        'nombreDeMotte': nombreDeMotte,
        'poidsMotteMax': poidsMotteMax,
        'poidsMotteMin': poidsMotteMin,
        'poidsTotalJournee': poidsTotalJournee,
        'listeDesRendezVous':
            listeDesRendezVous.map((a) => a.toJson()).toList(),
      };
  // Créer un objet à partir du JSON
  factory Journee.fromJson(Map<String, dynamic> json) {
    return Journee(
      date: DateTime.parse(json['date']),
      chome: json['chome'],
      nombreDeMotte: json['nombreDeMotte'],
      poidsMotteMax: json['poidsMotteMax'],
      poidsMotteMin: json['poidsMotteMin'],
      poidsTotalJournee: json['poidsTotalJournee'],
      listeDesRendezVous: (json['listeDesRendezVous'] as List)
          .map((i) => RendezVous.fromJson(i))
          .toList(),
    );
  }
}

class Agenda {
  final int _moisDebutAgenda = 10; // Octobre.
  final int _nbMoisAgenda = 5;

  List<Journee> _listeJournee = [];
  int anneeAgenda = 0;

  Agenda();

  // Constructeur privé avec initialisations
  Agenda._privateConstructor() {
    _initlocalisation();
  }
  // Instance unique de la classe
  static final Agenda _instance = Agenda._privateConstructor();
  static Agenda get instance => _instance;

  Future<void> setAnneeAgenda(int annee) async {
    anneeAgenda = annee;

    File file = await getLocalFileName(annee);

    // then = callback qd methode async est finie:
    bool isPresent = await file.exists();
    if (isPresent) {
      // Lit le nouveau fichier et maj _listeJournee.

      await _lectureAgenda(file);
    } else {
      // Le fichier n'existe pas. On le construit vide.
      // Date de départ: octobre année demandée.
      DateTime startDate = DateTime(anneeAgenda, _moisDebutAgenda, 1);

      // Durée de cinq mois.
      DateTime endDate = DateTime(
        startDate.year,
        startDate.month + _nbMoisAgenda,
        startDate.day,
      );

      DateTime currentDate = startDate;

      while (currentDate.isBefore(endDate)) {
        // Par défaut, samedi et dimanche chomés.
        bool chome = false;
        if ((currentDate.weekday == 6) || (currentDate.weekday == 7)) {
          chome = true;
        }
        _listeJournee.add(
            Journee(date: currentDate, chome: chome, listeDesRendezVous: []));
        currentDate = addOneDay(currentDate);
      }
// Ecrit le nouveau fichier.
      _ecritureAgenda(file);
    }
  }

  Journee getJournee(DateTime date) {
    DateTime dateDebutAgenda = DateTime(anneeAgenda, _moisDebutAgenda, 1);
    int nombreDeJour = date.difference(dateDebutAgenda).inDays;
    if (nombreDeJour < 0) {
      nombreDeJour = 0;
    } else {
      if (nombreDeJour >= _listeJournee.length) {
        nombreDeJour = _listeJournee.length - 1;
      }
    }
    return _listeJournee[nombreDeJour];
  }

  String nombreDeRDV(DateTime date) {
    if (getJournee(date).chome == true) {
      return "Pas de RDV, journée chomée.";
    } else if (getJournee(date).listeDesRendezVous.isEmpty == true) {
      return "Pas de RDV.";
    } else {
      return "Nombre de RDV: ${getJournee(date).listeDesRendezVous.length}";
    }
  }

  int nombreDeMotte(DateTime date) {
    return getJournee(date).nombreDeMotte;
  }

  int poidsMinMotte(DateTime date) {
    return getJournee(date).poidsMotteMin;
  }

  int poidsMaxMotte(DateTime date) {
    return getJournee(date).poidsMotteMax;
  }

  int poidsTotalJournee(DateTime date) {
    int poids = 0;
    for (RendezVous rendezVous in getJournee(date).listeDesRendezVous) {
      poids = poids + rendezVous.poidsCeuillette;
    }
    return poids;
  }

  Future<void> _initlocalisation() async {
    // Initialiser la localisation française
    await initializeDateFormatting('fr_FR', null);
    Intl.defaultLocale = 'fr_FR';
  }

  DateTime addOneDay(DateTime date) {
    return DateTime(date.year, date.month, date.day + 1);
  }

  String jourDeLaSemaine(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  String date2String(DateTime date) {
    return '${DateFormat('EEEE').format(date)} ${DateFormat('d').format(date)} ${DateFormat('MMMM').format(date)}';
  }

  String dateDuJour() {
    DateTime date = DateTime.now();
    return date2String(date);
  }

  Future<File> getLocalFileName(int annee) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    return File('$path/AA_O_C_Agenda$annee.json');
  }

  Future<void> _lectureAgenda(File file) async {
    final jsonString = await file.readAsString();
    final jsonList = jsonDecode(jsonString) as List;
    _listeJournee = jsonList.map((json) => Journee.fromJson(json)).toList();
  }

  Future<void> _ecritureAgenda(File file) async {
    final jsonString =
        jsonEncode(_listeJournee.map((day) => day.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}
