import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class Parametres {
  Map<String, dynamic> _mapDesParametres = {};

  double get poidsMotteMax {
    return _mapDesParametres["poidsMotteMax"];
  }

  set poidsMotteMax(double value) {
    _mapDesParametres["poidsMotteMax"] = value;
  }

  double get poidsMotteMin {
    return _mapDesParametres["poidsMotteMin"];
  }

  set poidsMotteMin(double value) {
    _mapDesParametres["poidsMotteMin"] = value;
  }

  String get nomFichierAdherents {
    return _mapDesParametres["nomFichierAdherents"];
  }

  set nomFichierAdherents(String value) {
    _mapDesParametres["nomFichierAdherents"] = value;
  }

  Parametres();
  // Constructeur privé avec initialisations
  Parametres._privateConstructor() {
    // Init avant lecture fichier.

    nomFichierAdherents =
        "C:/Users/jean-/OneDrive/Documents/moulinDeCallianAdhérentsMai2024.csv";
    poidsMotteMax = 50.0; //kg
    poidsMotteMin = 30.0; //kg

    // Init avant lecture fichier.
  }
  // Instance unique de la classe
  static final Parametres _instance = Parametres._privateConstructor();
  static Parametres get instance => _instance;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get _localfilename async {
    final path = await _localPath;
    return '$path/AOCParametres.json';
  }

  Future<File> get _localFile async {
    final filename = await _localfilename;
    return File(filename);
  }

  Future<void> lectureFichierParametres() async {
    final filename = await _localfilename;

    try {
      // Lire le fichier entier
      final file = File(filename);
      final jsonString = await file.readAsString();

      // Décoder le JSON
      _mapDesParametres = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Erreur lors de la lecture ou du décodage du fichier JSON : $e');
      _mapDesParametres = {};
    }
    print('Fichier json lu : $filename');
    print(_mapDesParametres);
  }

  Future<void> ecritureFichierParametres() async {
    // Convertir les données en format JSON.
    String jsonData = jsonEncode(_mapDesParametres);
    print(jsonData);

    // Écrire les données dans le fichier
    final file = await _localFile;
    await file.writeAsString(jsonData);

    final filename = await _localfilename;
    print('Fichier json sauvegardé : $filename');
  }

  @override
  String toString() {
    return """Parametres( $_mapDesParametres
     )""";
  }
}
