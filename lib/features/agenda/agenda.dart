import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:app_a_o_c/pages/agenda/filtre_config_generale.dart';
import 'package:app_a_o_c/shared/utils/app_config.dart';
import 'package:app_a_o_c/shared/utils/date_utilitaire.dart';
import 'package:path_provider/path_provider.dart';

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

class CaracteristiquesJournee {
  bool chome = false; // true = chomé.

  int nombreDeMotte = 3;
  int poidsMotteMax = 250; // en kg
  int poidsMotteMin = 200; // en kg
  int poidsTotalJournee = 0; // en kg

  CaracteristiquesJournee({
    this.chome = false,
    this.nombreDeMotte = 3,
    this.poidsMotteMax = 250,
    this.poidsMotteMin = 200,
    this.poidsTotalJournee = 0,
  });

  CaracteristiquesJournee copie() {
    return (CaracteristiquesJournee(
      chome: chome,
      nombreDeMotte: nombreDeMotte,
      poidsMotteMax: poidsMotteMax,
      poidsMotteMin: poidsMotteMin,
      poidsTotalJournee: poidsTotalJournee,
    ));
  }

  void copyCaracteristiquesJournee(CaracteristiquesJournee caracFrom) {
    chome = caracFrom.chome;
    nombreDeMotte = caracFrom.nombreDeMotte;
    poidsMotteMax = caracFrom.poidsMotteMax;
    poidsMotteMin = caracFrom.poidsMotteMin;
  }

  // Convertir en JSON.
  Map<String, dynamic> toJson() => {
        'chome': chome,
        'nombreDeMotte': nombreDeMotte,
        'poidsMotteMax': poidsMotteMax,
        'poidsMotteMin': poidsMotteMin,
        'poidsTotalJournee': poidsTotalJournee,
      };
// Créer un objet à partir du JSON
  factory CaracteristiquesJournee.fromJson(Map<String, dynamic> json) {
    return CaracteristiquesJournee(
      chome: json['chome'],
      nombreDeMotte: json['nombreDeMotte'],
      poidsMotteMax: json['poidsMotteMax'],
      poidsMotteMin: json['poidsMotteMin'],
      poidsTotalJournee: json['poidsTotalJournee'],
    );
  }
}

class Journee {
  final List<RendezVous> listeDesRendezVous;
  final CaracteristiquesJournee caracteristiquesJournee;
  Journee({
    required this.caracteristiquesJournee,
    required this.listeDesRendezVous,
  });

  void majCaracteristiquesJournee(CaracteristiquesJournee caracFrom) {
    caracteristiquesJournee.copyCaracteristiquesJournee(caracFrom);
  }

  // Convertir un objet en JSON
  Map<String, dynamic> toJson() => {
        'caracteristiquesJournee': caracteristiquesJournee,
        'listeDesRendezVous':
            listeDesRendezVous.map((a) => a.toJson()).toList(),
      };
  // Créer un objet à partir du JSON
  factory Journee.fromJson(Map<String, dynamic> json) {
    return Journee(
      caracteristiquesJournee:
          CaracteristiquesJournee.fromJson(json['caracteristiquesJournee']),
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

  // Instance unique de la classe
  static final Agenda _instance = Agenda();
  static Agenda get instance => _instance;

  int get moisDebutAgenda {
    return _moisDebutAgenda;
  }

  int get nbMoisAgenda {
    return _nbMoisAgenda;
  }

// Liste des jours de la semaine sur une période.
  List<bool> listeJourSemaineSurPeriode(DateTime dateDebut, DateTime dateFin) {
    List<bool> listeJour = [false, false, false, false, false, false, false];
    DateTime dateCourante = dateDebut;
    DateTime dateFinPlusUn = DateUtilitaire.addOneDay(dateFin);
    DateTime dateFinPlusHuit = dateFin.add(Duration(days: 8));

    while ((dateCourante.isBefore(dateFinPlusUn)) &&
        (dateCourante.isBefore(dateFinPlusHuit))) {
      listeJour[dateCourante.weekday - 1] = true;
      dateCourante = DateUtilitaire.addOneDay(dateCourante);
    }
    return listeJour;
  }

// Maj des Caracteristiques d'un journée ( sauf poids total fixé par rdv)
  Future<void> majCaracteristiquesJournee(DateTime dateDebut, DateTime dateFin,
      List<bool> dayToApply, CaracteristiquesJournee caracFrom) async {
    File file = await getLocalFileName(anneeAgenda);

    DateTime dateCourante = dateDebut;
    DateTime dateFinPlusUn = DateUtilitaire.addOneDay(dateFin);
    while (dateCourante.isBefore(dateFinPlusUn)) {
      if (dayToApply[dateCourante.weekday - 1] || (dateDebut == dateFin)) {
        getJournee(dateCourante).majCaracteristiquesJournee(caracFrom);
      }
      dateCourante = DateUtilitaire.addOneDay(dateCourante);
    }
    // Maj le fichier.
    _ecritureAgenda(file);
  }
/*
// Recherche de la première date avec une dipo donnée.
  DateTime rendezVousAuPlusTot(int poids) {
    DateTime dateCourante = currentDate;

    DateTime startDate = DateTime(anneeAgenda, _moisDebutAgenda, 1);
    DateTime dateFin = DateTime(
      startDate.year,
      startDate.month + _nbMoisAgenda,
      startDate.day,
    );
    DateTime dateFinPlusUn = DateUtilitaire.addOneDay(dateFin);
    while ((dateCourante.isBefore(dateFinPlusUn)) &&
        (poidsTotalJournee(dateCourante) + poids >
            poidsMaxMotte(dateCourante) * nombreDeMotte(dateCourante))) {???}
  }
*/
  bool isCaracteristiqueJourneeIdentique(
      DateTime date, CaracteristiquesJournee caracEdite) {
    return ((getJournee(date).caracteristiquesJournee.chome ==
            caracEdite.chome) &
        (getJournee(date).caracteristiquesJournee.nombreDeMotte ==
            caracEdite.nombreDeMotte) &
        (getJournee(date).caracteristiquesJournee.poidsMotteMax ==
            caracEdite.poidsMotteMax) &
        (getJournee(date).caracteristiquesJournee.poidsMotteMin ==
            caracEdite.poidsMotteMin));
  }

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

      DateTime dateCourante = startDate;
      bool chome = false;
      while (dateCourante.isBefore(endDate)) {
        // Par défaut, samedi et dimanche chomés.
        chome = false;
        if ((dateCourante.weekday == 6) || (dateCourante.weekday == 7)) {
          chome = true;
        }
        _listeJournee.add(Journee(
            caracteristiquesJournee: CaracteristiquesJournee(chome: chome),
            listeDesRendezVous: []));
        dateCourante = DateUtilitaire.addOneDay(dateCourante);
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

  void setCarecteristiqueJournee(DateTime date) {}

  String nombreDeRDV(DateTime date) {
    if (getJournee(date).caracteristiquesJournee.chome == true) {
      return "Pas de RDV, journée chomée.";
    } else if (getJournee(date).listeDesRendezVous.isEmpty == true) {
      return "Pas de RDV.";
    } else {
      return "Nombre de RDV: ${getJournee(date).listeDesRendezVous.length}";
    }
  }

  bool isChome(DateTime date) {
    return getJournee(date).caracteristiquesJournee.chome;
  }

  int nombreDeMotte(DateTime date) {
    return getJournee(date).caracteristiquesJournee.nombreDeMotte;
  }

  int poidsMinMotte(DateTime date) {
    return getJournee(date).caracteristiquesJournee.poidsMotteMin;
  }

  int poidsMaxMotte(DateTime date) {
    return getJournee(date).caracteristiquesJournee.poidsMotteMax;
  }

  int poidsTotalJournee(DateTime date) {
    int poids = 0;
    for (RendezVous rendezVous in getJournee(date).listeDesRendezVous) {
      poids = poids + rendezVous.poidsCeuillette;
    }
    return poids;
  }

  String intKg2KgOuT(int kg) {
    String returnValue = "";

    if (kg < 1000) {
      returnValue = "${kg.toString().padLeft(3)} kg";
    } else {
      double pmf = kg / 1000.0;
      returnValue = "${pmf.toStringAsFixed(2)} t";
    }
    return returnValue;
  }

  String getCaracteritiqueForDay(
      FiltrePourCalendier filtrePourCalendier, DateTime date) {
    String returnValue = "";
    CaracteristiquesJournee caracteristiquesJournee =
        getJournee(date).caracteristiquesJournee;
    switch (filtrePourCalendier) {
      case FiltrePourCalendier.chome:
        if (caracteristiquesJournee.chome == true) {
          returnValue = "chomée";
        } else {
          returnValue = "travaillée";
        }
        break;
      case FiltrePourCalendier.nombreMotte:
        returnValue = "${caracteristiquesJournee.nombreDeMotte}";
        break;
      case FiltrePourCalendier.poidsMax:
        returnValue = intKg2KgOuT(caracteristiquesJournee.poidsMotteMax);
        break;
      case FiltrePourCalendier.poidsMin:
        returnValue = intKg2KgOuT(caracteristiquesJournee.poidsMotteMin);
        break;
      case FiltrePourCalendier.poidsReserve:
        returnValue = intKg2KgOuT(caracteristiquesJournee.poidsTotalJournee);
        break;
      case FiltrePourCalendier.poidsDisponible:
        int pm = 0;
        if (caracteristiquesJournee.chome == false) {
          pm = caracteristiquesJournee.nombreDeMotte *
                  caracteristiquesJournee.poidsMotteMax -
              caracteristiquesJournee.poidsTotalJournee;
        }
        returnValue = intKg2KgOuT(pm);
        break;
    }
    return returnValue;
  }

  Future<File> getLocalFileName(int annee) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    return File('$path/app_a_o_c_Agenda$annee.json');
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
