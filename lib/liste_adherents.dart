
class Adherent {
  Adherent(this._civilite, this._nom, this._prenom);

  String _civilite = "";
  String get civilite => _civilite;

  set civilite(String value) {
    _civilite = value;
  }

  String _nom = "";
  String get nom => _nom;

  set nom(String value) {
    _nom = value;
  }

  String _prenom = "";
  String get prenom => _prenom;

  set prenom(String value) {
    _prenom = value;
  }

  String _noRue = "";

  String get noRue => _noRue;

  set noRue(String value) {
    _noRue = value;
  }

  String _adresse = "";

  String get adresse => _adresse;

  set adresse(String value) {
    _adresse = value;
  }

  String _complementAdresse = "";

  String get complementAdresse => _complementAdresse;

  set complementAdresse(String value) {
    _complementAdresse = value;
  }

  String _codePostal = "";

  String get codePostal => _codePostal;

  set codePostal(String value) {
    _codePostal = value;
  }

  String _commune = "";

  String get commune => _commune;

  set commune(String value) {
    _commune = value;
  }

  String _noTelephone = "";

  String get noTelephone => _noTelephone;

  set noTelephone(String value) {
    _noTelephone = value;
  }

  String _adresseMail = "";

  String get adresseMail => _adresseMail;

  set adresseMail(String value) {
    _adresseMail = value;
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
  List<Adherent> listeAdherentsComplet = [];
  List<Adherent> listeAdherentsRecherche = [];
  // Sera soit complet soit recherche.
  List<Adherent> listeAdherentsCourant = [];

  // Indice dans la liste courante.
  int indiceAdherentCourant = 0;
  Adherent _adherentCourant = Adherent("", "", "");

  Adherent get adherentCourant => _adherentCourant;

  set adherentCourant(Adherent value) {
    _adherentCourant = value;
  }

  Adherent adherentVide = Adherent("", "", "");

  // Constructeur privé avec initialisations
  ListeAdherents._privateConstructor() {
    // Init avant lecture fichier.
    listeAdherentsComplet.add(Adherent("M", "Espalongo", "Stanley"));
    listeAdherentsComplet.add(Adherent("Mme", "Espalongo", "Pierre"));
    listeAdherentsComplet.add(Adherent("Mme ou M", "Toto", "Paul"));
    listeAdherentsComplet.add(Adherent(" ", "Titi", "Jean"));
    listeAdherentsComplet.add(Adherent("M", "Tata", "Jacques"));
    for (int indice = 0; indice < listeAdherentsComplet.length; indice++) {
      listeAdherentsComplet[indice].noRue = '$indice';
      listeAdherentsComplet[indice].adresse = 'rue longue$indice';
      listeAdherentsComplet[indice].complementAdresse =
          'Les bas adrechs$indice';
      listeAdherentsComplet[indice].codePostal = '8344$indice';
      listeAdherentsComplet[indice].commune = 'Callian$indice';
      listeAdherentsComplet[indice].noTelephone = '06 12 34 56 7$indice';
      listeAdherentsComplet[indice].adresseMail =
          'espalongo$indice.stanley@boitemail.fr';
    }

// Init au debut.
    listeAdherentsCourant = listeAdherentsComplet;
    indiceAdherentCourant = 0;
    adherentCourant = listeAdherentsComplet[indiceAdherentCourant];
  }

// Instance unique de la classe
  static final ListeAdherents instance = ListeAdherents._privateConstructor();

  void setAdherentPrecedent() {
    if (listeAdherentsCourant.isNotEmpty) {
      indiceAdherentCourant =
          (indiceAdherentCourant - 1) % (listeAdherentsCourant.length);
      adherentCourant = listeAdherentsCourant[indiceAdherentCourant];
    } else {
      indiceAdherentCourant = 0;
      adherentCourant = adherentVide;
    }
    print(indiceAdherentCourant);

    print(
        'setAdherentPrecedent adherentCourant:$adherentCourant\n listeAdherents:$listeAdherentsCourant');
  }

  void setAdherentSuivant() {
    if (listeAdherentsCourant.isNotEmpty) {
      indiceAdherentCourant =
          (indiceAdherentCourant + 1) % (listeAdherentsCourant.length);
      adherentCourant = listeAdherentsCourant[indiceAdherentCourant];
    } else {
      indiceAdherentCourant = 0;
      adherentCourant = adherentVide;
    }
    print(indiceAdherentCourant);

    print(
        'setAdherentSuivant adherentCourant:$adherentCourant\n listeAdherents:$listeAdherentsCourant');
  }

  void searchStingInName(String text) {
    listeAdherentsRecherche.clear();
    indiceAdherentCourant = 0;

    for (var adher in listeAdherentsComplet) {
      if (adher.nom.toLowerCase().contains(text.toLowerCase())) {
        listeAdherentsRecherche.add(adher);
      }
    }
    if (listeAdherentsRecherche.isEmpty) {
             listeAdherentsRecherche.add(adherentVide);
    }

    listeAdherentsCourant = listeAdherentsRecherche;
    adherentCourant = listeAdherentsCourant[indiceAdherentCourant];

    print(
        'searchStingInName adherentCourant:$adherentCourant\n listeAdherents:$listeAdherentsCourant');
  }

  @override
  String toString() {
    return 'ListeAdherents( indiceAdherentCourant:$indiceAdherentCourant adherentCourant: $adherentCourant)';
  }
}
