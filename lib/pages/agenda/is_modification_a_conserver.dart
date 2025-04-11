import 'package:app_a_o_c/features/agenda/agenda.dart';
import 'package:app_a_o_c/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void isModificationAConserver(
    BuildContext context,
    DateTime date,
    DateTime dateDebut,
    DateTime dateFin,
    List<bool> isChecked,
    CaracteristiquesJournee caracEdite) {
  if (Agenda.instance.isCaracteristiqueJourneeIdentique(date, caracEdite) &&
      (dateDebut == date) &&
      (dateFin == date)) {
    // Tout est identique, on sort sans rien demander.
    Navigator.pop(context);
  } else {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Des modifications ont été effectuées!'),
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
              Agenda.instance.majCaracteristiquesJournee(
                  dateDebut, dateFin, isChecked, caracEdite);
              // Notifie les listeners si nécessaire
              context.read<MyAppState>().majCaracteristiquesJournee();

              // Retourne à la page précédente .
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Oui!'),
          ),
        ],
      ),
    );
  }
}

