import 'package:app_a_o_c/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSlider extends StatefulWidget {
  final String texteDescription;
  final String textUnite;

  const AppSlider(
      {super.key, required this.texteDescription, required this.textUnite});

  @override
  AppSliderState createState() => AppSliderState();
}

class AppSliderState extends State<AppSlider> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    double valeur = appState.getPoidsPourRendezVous().toDouble();
    return Column(
      children: [
        Text(
          '${widget.texteDescription}${valeur.toStringAsFixed(0)}${widget.textUnite}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        //SizedBox(height: 25),
        Slider(
          value: valeur,
          min: 0,
          max: 240,
          divisions: 24, // si tu veux des paliers fixes
          label: '${valeur.toStringAsFixed(0)}${widget.textUnite}',
          onChanged: (double nouvelleValeur) {
            setState(() {
              valeur = nouvelleValeur.round().toDouble();
              appState.majPoidsPourRendezVous(nouvelleValeur.round());
            });
          },
        ),
      ],
    );
  }
}
