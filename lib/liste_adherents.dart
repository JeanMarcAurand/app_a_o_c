import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class Adherent {
  Adherent(this._civilite, this._nom, this._prenom);

  String _civilite = "";
  String get civilite => _civilite;

  set civilite(String value) {
    _civilite = value;
  }

  void setCivilite(String value) {
    _civilite = value;
  }

  String _nom = "";
  String get nom => _nom;

  set nom(String value) {
    _nom = value;
  }

  void setNom(String value) {
    _nom = value;
  }

  String _prenom = "";
  String get prenom => _prenom;

  set prenom(String value) {
    _prenom = value;
  }

  void setPrenom(String value) {
    _prenom = value;
  }

  String _noRue = "";

  String get noRue => _noRue;

  set noRue(String value) {
    _noRue = value;
  }

  void setNoRue(String value) {
    _noRue = value;
  }

  String _adresse = "";

  String get adresse => _adresse;

  set adresse(String value) {
    _adresse = value;
  }

  void setAdresse(String value) {
    _adresse = value;
  }

  String _complementAdresse = "";

  String get complementAdresse => _complementAdresse;

  set complementAdresse(String value) {
    _complementAdresse = value;
  }

  void setComplementAdresse(String value) {
    _complementAdresse = value;
  }

  String _codePostal = "";

  String get codePostal => _codePostal;

  set codePostal(String value) {
    _codePostal = value;
  }

  void setCodePostal(String value) {
    _codePostal = value;
  }

  String _commune = "";

  String get commune => _commune;

  set commune(String value) {
    _commune = value;
  }

  void setCommune(String value) {
    _commune = value;
  }

  String _noTelephone = "";

  String get noTelephone => _noTelephone;

  set noTelephone(String value) {
    _noTelephone = value;
  }

  void setNoTelephone(String value) {
    _noTelephone = value;
  }

  String _adresseMail = "";

  String get adresseMail => _adresseMail;

  set adresseMail(String value) {
    _adresseMail = value;
  }

  void setAdresseMail(String value) {
    _adresseMail = value;
  }

  void copyAdherentFrom(Adherent adherentSource) {
    civilite = adherentSource.civilite;
    nom = adherentSource.nom;
    prenom = adherentSource.prenom;
    noRue = adherentSource.noRue;
    adresse = adherentSource.adresse;
    complementAdresse = adherentSource.complementAdresse;
    codePostal = adherentSource.codePostal;
    commune = adherentSource.commune;
    noTelephone = adherentSource.noTelephone;
    adresseMail = adherentSource.adresseMail;
  }

  bool isAdherentIdentique(Adherent adherent) {
    return (civilite == adherent.civilite) &&
        (nom == adherent.nom) &&
        (prenom == adherent.prenom) &&
        (noRue == adherent.noRue) &&
        (adresse == adherent.adresse) &&
        (complementAdresse == adherent.complementAdresse) &&
        (codePostal == adherent.codePostal) &&
        (commune == adherent.commune) &&
        (noTelephone == adherent.noTelephone) &&
        (adresseMail == adherent.adresseMail);
  }

  @override
  String toString() {
    return """Adherent( _civilite:$_civilite _nom:$_nom _prenom:$_prenom 
            _noRue:$_noRue _adresse:$_adresse
            _complementAdresse:$_complementAdresse
            _codePostal:$_codePostal _commune:$_commune
            _noTelephone:$_noTelephone 
            _adresseMail:$_adresseMail)""";
  }
}

class ListeAdherents {
  List<Adherent> _listeAdherentsComplet = [];
  List<Adherent> get listeAdherentsComplet => _listeAdherentsComplet;
  List<Adherent> _listeAdherentsRecherche = [];
  // Sera soit complet soit recherche.
  List<Adherent> _listeAdherentsCourant = [];
  List<Adherent> get listeAdherentsCourant => _listeAdherentsCourant;

  // Indice dans la liste courante.
  int _indiceAdherentCourant = 0;
  Adherent _adherentCourant = Adherent("", "", "");

  Adherent get adherentCourant => _adherentCourant;

  set adherentCourant(Adherent value) {
    _adherentCourant = value;
  }

  Adherent adherentVide = Adherent("", "", "");
  String _dernierTextRecherche = "";

  // Constructeur privé avec initialisations
  ListeAdherents._privateConstructor() {
    // Init avant lecture fichier.
    _listeAdherentsComplet.add(Adherent("M", "Espalongo", "Stanley"));
    _listeAdherentsComplet.add(Adherent("Mme", "Espalongo", "Pierre"));
    _listeAdherentsComplet.add(Adherent("Mme ou M", "Toto", "Paul"));
    _listeAdherentsComplet.add(Adherent(" ", "Titi", "Jean"));
    _listeAdherentsComplet.add(Adherent("M", "Tata", "Jacques"));
    for (int indice = 0; indice < _listeAdherentsComplet.length; indice++) {
      _listeAdherentsComplet[indice].noRue = '$indice';
      _listeAdherentsComplet[indice].adresse = 'rue longue$indice';
      _listeAdherentsComplet[indice].complementAdresse =
          'Les bas adrechs$indice';
      _listeAdherentsComplet[indice].codePostal = '8344$indice';
      _listeAdherentsComplet[indice].commune = 'Callian$indice';
      _listeAdherentsComplet[indice].noTelephone = '06 12 34 56 7$indice';
      _listeAdherentsComplet[indice].adresseMail =
          'espalongo$indice.stanley@boitemail.fr';
    }

//    lectureFichierAdherents();

// Init au debut.
    _listeAdherentsCourant = _listeAdherentsComplet;
    _indiceAdherentCourant = 0;
    adherentCourant = _listeAdherentsComplet[_indiceAdherentCourant];
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    print('Path: $path');
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/moulinDeCallianAdhérentsMai2024.csv');
  }

  Future<Stream<List<dynamic>>> readCSVAsStream() async {
    // Lire le fichier en tant que stream
    final file = await _localFile;
    final inputStream = file.openRead();

    // Parser le contenu du fichier CSV
    return inputStream
        .transform(utf8.decoder)
        .transform(CsvToListConverter(fieldDelimiter: ';'));
  }

  Future<List<List<dynamic>>> readCSV() async {
    // Lire le fichier
    final file = await _localFile;
    final csvString = await file.readAsString();

    // Parser le contenu du fichier CSV
    List<List<dynamic>> csvTable =
        CsvToListConverter(fieldDelimiter: ';').convert(csvString);
    return csvTable;
  }

  Future<void> lectureFichierAdherents() async {
    final path = await _localPath;
    print("fichier $path");
    _listeAdherentsComplet.clear();
    final csvStream = await readCSVAsStream();
    bool isFirstRow = true;
    List<dynamic> firstRow = [];

    await for (var row in csvStream) {
      // Appliquer les transformations ou traitements nécessaires
      print(row);
      if (isFirstRow) {
        isFirstRow = false;
        firstRow = row;
      } else {
        Adherent adherent = Adherent(row[firstRow.indexOf("Civilité")],
            row[firstRow.indexOf("Nom")], row[firstRow.indexOf("Prénom")]);
        adherent.noRue = row[firstRow.indexOf("No")].toString();
        adherent.adresse = row[firstRow.indexOf("Lieu")];
        adherent.complementAdresse = row[firstRow.indexOf("Rue")];
        adherent.codePostal = row[firstRow.indexOf("Code")].toString();
        adherent.commune = row[firstRow.indexOf("Ville")];
        adherent.noTelephone = row[firstRow.indexOf("Tel portable")];
        if (adherent.noTelephone.isEmpty) {
          adherent.noTelephone = row[firstRow.indexOf("Tel fixe")];
        }
        adherent.adresseMail = row[firstRow.indexOf("adresse mail")];
        _listeAdherentsComplet.add(adherent);
      }
    }
    // Init au debut.
    _listeAdherentsCourant = _listeAdherentsComplet;
    _indiceAdherentCourant = 0;
    adherentCourant = _listeAdherentsComplet[_indiceAdherentCourant];
  }

// Instance unique de la classe
  static final ListeAdherents _instance = ListeAdherents._privateConstructor();
  static ListeAdherents get instance => _instance;

  void setAdherentPrecedent() {
    if (_listeAdherentsCourant.isNotEmpty) {
      _indiceAdherentCourant =
          (_indiceAdherentCourant - 1) % (_listeAdherentsCourant.length);
      adherentCourant = _listeAdherentsCourant[_indiceAdherentCourant];
    } else {
      _indiceAdherentCourant = 0;
      adherentCourant = adherentVide;
    }
    //print(indiceAdherentCourant);
    //print(
    //    'setAdherentPrecedent adherentCourant:$adherentCourant\n listeAdherents:$listeAdherentsCourant');
  }

  void setAdherentSuivant() {
    if (_listeAdherentsCourant.isNotEmpty) {
      _indiceAdherentCourant =
          (_indiceAdherentCourant + 1) % (_listeAdherentsCourant.length);
      adherentCourant = _listeAdherentsCourant[_indiceAdherentCourant];
    } else {
      _indiceAdherentCourant = 0;
      adherentCourant = adherentVide;
    }
    //print(indiceAdherentCourant);
    //print(
    //    'setAdherentSuivant adherentCourant:$adherentCourant\n listeAdherents:$listeAdherentsCourant');
  }

  void searchStingInName(String text) {
    _dernierTextRecherche = text;
    _listeAdherentsRecherche.clear();
    _indiceAdherentCourant = 0;

    for (var adher in _listeAdherentsComplet) {
      if (adher.nom.toLowerCase().contains(text.toLowerCase())) {
        _listeAdherentsRecherche.add(adher);
      }
    }
    if (_listeAdherentsRecherche.isEmpty) {
      _listeAdherentsRecherche.add(adherentVide);
    }

    _listeAdherentsCourant = _listeAdherentsRecherche;
    adherentCourant = _listeAdherentsCourant[_indiceAdherentCourant];

    //print(
    //    'searchStingInName adherentCourant:$adherentCourant\n listeAdherents:$listeAdherentsCourant');
  }

  void deleteAdherentCourant() {
    _listeAdherentsComplet.remove(adherentCourant);
    _listeAdherentsCourant.remove(adherentCourant);
    if (_indiceAdherentCourant > 0) {
      _indiceAdherentCourant--;
    }
    if (_listeAdherentsCourant.isEmpty) {
      _listeAdherentsCourant.add(adherentVide);
      _indiceAdherentCourant = 0;
    }
    adherentCourant = _listeAdherentsCourant[_indiceAdherentCourant];
  }

  void createAdherentEdite(Adherent adherent) {
    Adherent nouvelAdherent = Adherent("", "", "");
    nouvelAdherent.copyAdherentFrom(adherent);

    _listeAdherentsComplet.add(nouvelAdherent);
    _listeAdherentsComplet
        .sort((a, b) => a.nom.toLowerCase().compareTo(b.nom.toLowerCase()));

    if (_listeAdherentsComplet == _listeAdherentsCourant) {
      // On n'est pas dans un mode de recherche.
      _indiceAdherentCourant = _listeAdherentsCourant.indexOf(nouvelAdherent);
      adherentCourant = nouvelAdherent;
    } else {
      // On est dans un mode de recherche.
      if (nouvelAdherent.nom
          .toLowerCase()
          .contains(_dernierTextRecherche.toLowerCase())) {
        _listeAdherentsCourant.add(nouvelAdherent);
        _listeAdherentsCourant
            .sort((a, b) => a.nom.toLowerCase().compareTo(b.nom.toLowerCase()));
        _indiceAdherentCourant = _listeAdherentsCourant.indexOf(nouvelAdherent);
        adherentCourant = nouvelAdherent;
      }
    }
  }

  void majAdherentEdite(Adherent adherent) {
    adherentCourant.copyAdherentFrom(adherent);
    _listeAdherentsCourant
        .sort((a, b) => a.nom.toLowerCase().compareTo(b.nom.toLowerCase()));
    _indiceAdherentCourant = _listeAdherentsCourant.indexOf(adherentCourant);
  }

  @override
  String toString() {
    return 'ListeAdherents( indiceAdherentCourant:$_indiceAdherentCourant adherentCourant: $adherentCourant)';
  }
}
