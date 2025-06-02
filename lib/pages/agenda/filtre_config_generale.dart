import 'package:app_a_o_c/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FiltrePourCalendier {
  chome,
  nombreMotte,
  poidsMax,
  poidsMin,
  poidsReserve,
  poidsDisponible
}

class FiltreConfigGenerale extends StatefulWidget {
  const FiltreConfigGenerale({super.key});

  @override
  State<FiltreConfigGenerale> createState() => _FiltreConfigGeneraleState();
}

class _FiltreConfigGeneraleState extends State<FiltreConfigGenerale> {
  FiltrePourCalendier _filtrePourCalendrier =
      FiltrePourCalendier.poidsDisponible;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        Text(
          'Filtres: ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap:
              true, // important pour que le grid ne prenne que l'espace nécessaire
          childAspectRatio: 6, // adapte la forme des cellules
          children: [
            RadioListTile<FiltrePourCalendier>(
              value: FiltrePourCalendier.chome,
              groupValue: _filtrePourCalendrier,
              onChanged: (FiltrePourCalendier? value) {
                setState(() {
                  _filtrePourCalendrier = value!;
                  appState.majFiltrePourCalendier(value);
                });
              },
              title: Text("Journée chomée."),
            ),
            RadioListTile<FiltrePourCalendier>(
              value: FiltrePourCalendier.nombreMotte,
              groupValue: _filtrePourCalendrier,
              onChanged: (FiltrePourCalendier? value) {
                setState(() {
                  _filtrePourCalendrier = value!;
                  appState.majFiltrePourCalendier(value);
                });
              },
              title: Text("Nombre de mottes."),
            ),
            RadioListTile<FiltrePourCalendier>(
              value: FiltrePourCalendier.poidsMax,
              groupValue: _filtrePourCalendrier,
              onChanged: (FiltrePourCalendier? value) {
                setState(() {
                  _filtrePourCalendrier = value!;
                  appState.majFiltrePourCalendier(value);
                });
              },
              title: Text("Poids max motte."),
            ),
            RadioListTile<FiltrePourCalendier>(
              value: FiltrePourCalendier.poidsMin,
              groupValue: _filtrePourCalendrier,
              onChanged: (FiltrePourCalendier? value) {
                setState(() {
                  _filtrePourCalendrier = value!;
                  appState.majFiltrePourCalendier(value);
                });
              },
              title: Text("Poids min motte."),
            ),
            RadioListTile<FiltrePourCalendier>(
              value: FiltrePourCalendier.poidsDisponible,
              groupValue: _filtrePourCalendrier,
              onChanged: (FiltrePourCalendier? value) {
                setState(() {
                  _filtrePourCalendrier = value!;
                  appState.majFiltrePourCalendier(value);
                });
              },
              title: Text("Poids disponible."),
            ),
            RadioListTile<FiltrePourCalendier>(
              value: FiltrePourCalendier.poidsReserve,
              groupValue: _filtrePourCalendrier,
              onChanged: (FiltrePourCalendier? value) {
                setState(() {
                  _filtrePourCalendrier = value!;
                  appState.majFiltrePourCalendier(value);
                });
              },
              title: Text("Poids réservé."),
            ),
          ],
        )
      ],
    );
  }
}
