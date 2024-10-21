import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

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

  String _noTelephoneFixe = "";
  String get noTelephoneFixe => _noTelephoneFixe;
  set noTelephoneFixe(String value) {
    _noTelephoneFixe = value;
  }

  void setNoTelephoneFixe(String value) {
    _noTelephoneFixe = value;
  }

  String _noTelephonePortable = "";
  String get noTelephonePortable => _noTelephonePortable;
  set noTelephonePortable(String value) {
    _noTelephonePortable = value;
  }

  void setNoTelephonePortable(String value) {
    _noTelephonePortable = value;
  }

  String _adresseMail = "";
  String get adresseMail => _adresseMail;
  set adresseMail(String value) {
    _adresseMail = value;
  }

  void setAdresseMail(String value) {
    _adresseMail = value;
  }

  String _dateDerniereMAJ = "";
  String get dateDerniereMAJ => _dateDerniereMAJ;
  set dateDerniereMAJ(String value) {
    _dateDerniereMAJ = value;
  }

  void setDateDerniereMAJ(String value) {
    _dateDerniereMAJ = value;
  }

  String _sourceDerniereMAJ = "";
  String get sourceDerniereMAJ => _sourceDerniereMAJ;
  set sourceDerniereMAJ(String value) {
    _sourceDerniereMAJ = value;
  }

  void setSourceDerniereMAJ(String value) {
    _sourceDerniereMAJ = value;
  }

  int _identificateur = 0;

  int get identificateur => _identificateur;

  set identificateur(int value) {
    _identificateur = value;
  }

  String _dateCreation = "";

  String get dateCreation => _dateCreation;

  set dateCreation(String value) {
    _dateCreation = value;
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
    noTelephoneFixe = adherentSource.noTelephoneFixe;
    noTelephonePortable = adherentSource.noTelephonePortable;
    adresseMail = adherentSource.adresseMail;
    dateDerniereMAJ = adherentSource.dateDerniereMAJ;
    sourceDerniereMAJ = adherentSource.sourceDerniereMAJ;
    identificateur = adherentSource.identificateur;
    dateCreation = adherentSource.dateCreation;
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
        (noTelephoneFixe == adherent.noTelephoneFixe) &&
        (noTelephonePortable == adherent.noTelephonePortable) &&
        (adresseMail == adherent.adresseMail) &&
        (dateDerniereMAJ == adherent.dateDerniereMAJ) &&
        (sourceDerniereMAJ == adherent.sourceDerniereMAJ) &&
        (identificateur == adherent.identificateur) &&
        (dateCreation == adherent.dateCreation);
  }

  @override
  String toString() {
    return """Adherent( _civilite:$_civilite _nom:$_nom _prenom:$_prenom 
            _noRue:$_noRue _adresse:$_adresse
            _complementAdresse:$_complementAdresse
            _codePostal:$_codePostal _commune:$_commune
            _noTelephoneFixe:$_noTelephoneFixe 
            _noTelephonePortable:$_noTelephonePortable
            _adresseMail:$_adresseMail
            _dateCreation:$_dateCreation
            _dateDerniereMAJ:$_dateDerniereMAJ
            _sourceDerniereMAJ:$_sourceDerniereMAJ 
            _identificateur:$_identificateur)""";
  }
}

class ListeAdherents {
  List<Adherent> _listeAdherentsComplet = [];
  List<Adherent> get listeAdherentsComplet => _listeAdherentsComplet;
  List<Adherent> _listeAdherentsRecherche = [];
  // Sera soit complet soit recherche.
  List<Adherent> _listeAdherentsCourant = [];
  List<Adherent> get listeAdherentsCourant => _listeAdherentsCourant;

  Adherent adherentVide = Adherent("", "", "");
  String _dernierTextRecherche = "";

  // Constructeur privé avec initialisations
  ListeAdherents._privateConstructor() {
    // Init avant lecture fichier.
    for (int indice = 0; indice < _listeAdherentsComplet.length; indice++) {
      _listeAdherentsComplet
          .add(Adherent("M$indice", "Exemple$indice", "Ex$indice-emple"));
      _listeAdherentsComplet[indice].noRue = '$indice';
      _listeAdherentsComplet[indice].adresse =
          'chemin du clos$indice des adrechs';
      _listeAdherentsComplet[indice].complementAdresse =
          'Les bas adrechs$indice';
      _listeAdherentsComplet[indice].codePostal = '8344$indice';
      _listeAdherentsComplet[indice].commune = 'Callian$indice';
      _listeAdherentsComplet[indice].noTelephoneFixe = '06 12 34 56 7$indice';
      _listeAdherentsComplet[indice].adresseMail =
          'exemple$indice.ex$indice-emple@boitemail.fr';
      _listeAdherentsComplet[indice]._dateCreation = "01/01/197$indice";
      _listeAdherentsComplet[indice]._dateDerniereMAJ = "02/01/197$indice";
      _listeAdherentsComplet[indice].sourceDerniereMAJ = "JMA$indice";
      _listeAdherentsComplet[indice]._identificateur = 1728777500 + indice;
    }

//    lectureFichierAdherents();

// Init au debut.
    _listeAdherentsCourant = _listeAdherentsComplet;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
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
        adherent.noTelephonePortable =
            row[firstRow.indexOf("Tel portable")].toString();
        adherent.noTelephoneFixe = row[firstRow.indexOf("Tel fixe")].toString();
        adherent.adresseMail = row[firstRow.indexOf("adresse mail")];
        adherent.dateDerniereMAJ = row[firstRow.indexOf("Derniere maj")];
        adherent.sourceDerniereMAJ = row[firstRow.indexOf("Source")];
        adherent.dateCreation = row[firstRow.indexOf("Date création")];
        adherent.identificateur = row[firstRow.indexOf("Identificateur")];
        _listeAdherentsComplet.add(adherent);
      }
    }
    // Init au debut.
    _listeAdherentsCourant = _listeAdherentsComplet;
  }

  Future<void> ecritureFichierAdherents() async {
// construit la liste.
    List<String> firstRow = [
      "Civilité",
      "Nom",
      "Prénom",
      "No",
      "Lieu",
      "Rue",
      "Code",
      "Ville",
      "Tel portable",
      "Tel fixe",
      "adresse mail",
      "Identificateur",
      "Date création",
      "Derniere maj",
      "Source"
    ];

    List<List<String>> adherents = [firstRow];
    for (Adherent adherent in _listeAdherentsComplet) {
      adherents.add([
        adherent.civilite,
        adherent.nom,
        adherent.prenom,
        adherent.noRue,
        adherent.adresse,
        adherent.complementAdresse,
        adherent.codePostal,
        adherent.commune,
        adherent.noTelephonePortable,
        adherent.noTelephoneFixe,
        adherent.adresseMail,
        adherent.identificateur.toString(),
        adherent.dateCreation,
        adherent.dateDerniereMAJ,
        adherent.sourceDerniereMAJ,
      ]);
    }

    // Convertir les données en format CSV
    String csvData =
        const ListToCsvConverter(fieldDelimiter: ';').convert(adherents);

    // Écrire les données dans le fichier
    final file = await _localFile;
    await file.writeAsString(csvData);

    print('Fichier CSV sauvegardé à : $_localFile');
  }

// Instance unique de la classe
  static final ListeAdherents _instance = ListeAdherents._privateConstructor();
  static ListeAdherents get instance => _instance;
/*
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
*/
  void searchStingInName(String text) {
    _dernierTextRecherche = text;
    _listeAdherentsRecherche.clear();

    for (var adher in _listeAdherentsComplet) {
      if (adher.nom.toLowerCase().contains(text.toLowerCase())) {
        _listeAdherentsRecherche.add(adher);
      }
    }
    if (_listeAdherentsRecherche.isEmpty) {
      _listeAdherentsRecherche.add(adherentVide);
    }

    _listeAdherentsCourant = _listeAdherentsRecherche;
    //print(
    //    'searchStingInName adherentCourant:$adherentCourant\n listeAdherents:$listeAdherentsCourant');
  }

  Future<void> deleteAdherent(Adherent adherent) async {
    _listeAdherentsComplet.remove(adherent);
    _listeAdherentsCourant.remove(adherent);

    if (_listeAdherentsCourant.isEmpty) {
      _listeAdherentsCourant.add(adherentVide);
    }
    await ecritureFichierAdherents();
  }

  Future<void> createAdherentEdite(Adherent adherent) async {
    Adherent nouvelAdherent = Adherent("", "", "");
    nouvelAdherent.copyAdherentFrom(adherent);
    nouvelAdherent.dateCreation =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    nouvelAdherent.dateDerniereMAJ = nouvelAdherent.dateCreation;
    nouvelAdherent.identificateur =
        DateTime.now().difference(DateTime.utc(1970, 1, 1)).inSeconds;
    nouvelAdherent.sourceDerniereMAJ = "créé aA_O_C";
    _listeAdherentsComplet.add(nouvelAdherent);
    _listeAdherentsComplet
        .sort((a, b) => a.nom.toLowerCase().compareTo(b.nom.toLowerCase()));

    if (_listeAdherentsComplet != _listeAdherentsCourant) {
      // On est dans un mode de recherche.
      if (nouvelAdherent.nom
          .toLowerCase()
          .contains(_dernierTextRecherche.toLowerCase())) {
        _listeAdherentsCourant.add(nouvelAdherent);
        _listeAdherentsCourant
            .sort((a, b) => a.nom.toLowerCase().compareTo(b.nom.toLowerCase()));
      }
    }

    await ecritureFichierAdherents();
  }

  Future<void> majAdherentEdite(
      Adherent editAd, Adherent localCurrentAd) async {
    editAd.dateDerniereMAJ = DateFormat('dd/MM/yyyy').format(DateTime.now());
    editAd.sourceDerniereMAJ = "modifié aA_O_C";
    localCurrentAd.copyAdherentFrom(editAd);
    _listeAdherentsCourant
        .sort((a, b) => a.nom.toLowerCase().compareTo(b.nom.toLowerCase()));

    await ecritureFichierAdherents();
  }

  @override
  String toString() {
    return 'ListeAdherents( )';
  }
}
